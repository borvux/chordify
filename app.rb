require "sinatra"
require "sinatra/reloader"
require "erb"
require 'active_support/core_ext/string/inflections'
require_relative 'lib/chord_transposer' 

enable :sessions

def songs_dir_path
  File.join(File.dirname(__FILE__), 'songs')
end

def get_available_songs
  Dir.glob(File.join(songs_dir_path, '*.txt')).map { |f| File.basename(f) }.sort
rescue Errno::ENOENT
  []
end

before do
  session[:song_transpositions] ||= {}
  @available_songs = get_available_songs

  # determine the current song from params or session, defaulting to the first available.
  @selected_song_filename = params[:song] || session[:current_song] || @available_songs.first
  session[:current_song] = @selected_song_filename
end

get '/' do
  if @available_songs.empty?
    status 404
    return "<h1>Error: No song files found!</h1><p>Please create a 'songs' directory and place .txt files inside it.</p>"
  end

  # ensure the selected song is valid, otherwise default to the first
  unless @selected_song_filename && @available_songs.include?(@selected_song_filename)
    @selected_song_filename = @available_songs.first
    session[:current_song] = @selected_song_filename # update session
  end

  song_file_path = File.join(songs_dir_path, @selected_song_filename)

  unless File.exist?(song_file_path)
    status 404
    return "<h1>Error: Song file '#{@selected_song_filename}' not found!</h1>"
  end

  # get the current transposition amount for THIS specific song
  @current_total_semitones = session[:song_transpositions][@selected_song_filename] || 0

  # read original content and apply transposition
  original_lines = File.readlines(song_file_path)
  transposed_lines = original_lines.map do |line|
    line_to_process = line.chomp
    if ChordTransposer.is_chord_line?(line_to_process)
      ChordTransposer.transpose_line(line_to_process, @current_total_semitones)
    else
      line_to_process # leave lyrics and other lines untouched
    end
  end

  @transposed_text = transposed_lines.join("\n")

  erb :index
end

post '/transpose' do
  redirect '/' unless session[:current_song]

  current_song = session[:current_song]

  # ensure the song has an entry in the session hash
  session[:song_transpositions][current_song] ||= 0

  case params[:direction]
  when 'up'
    session[:song_transpositions][current_song] += 1
  when 'down'
    session[:song_transpositions][current_song] -= 1
  when 'reset'
    session[:song_transpositions][current_song] = 0
  end

  redirect "/?song=#{current_song}"
end

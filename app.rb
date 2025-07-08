# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'erb'
require 'active_support/core_ext/string/inflections'
require_relative 'lib/chord_transposer'

enable :sessions

def songs_dir_path
  File.join(File.dirname(__FILE__), 'songs')
end

def available_songs
  Dir.glob(File.join(songs_dir_path, '*.txt')).map { |f| File.basename(f) }.sort
rescue Errno::ENOENT
  []
end

before do
  session[:song_transpositions] ||= {}
  @available_songs = available_songs

  @selected_song_filename = params[:song] || session[:current_song] || @available_songs.first
  session[:current_song] = @selected_song_filename
end

get '/' do
  if @available_songs.empty?
    status 404
    return "<h1>Error: No song files found!</h1><p>Please add .txt files inside the 'songs' directory .</p>"
  end

  unless @selected_song_filename && @available_songs.include?(@selected_song_filename)
    @selected_song_filename = @available_songs.first
    session[:current_song] = @selected_song_filename
  end

  song_file_path = File.join(songs_dir_path, @selected_song_filename)

  unless File.exist?(song_file_path)
    status 404
    return "<h1>Error: Song file '#{@selected_song_filename}' not found!</h1>"
  end

  @current_total_semitones = session[:song_transpositions][@selected_song_filename] || 0

  original_lines = File.readlines(song_file_path)
  transposed_lines = original_lines.map do |line|
    line_to_process = line.chomp
    if ChordTransposer.chord_line?(line_to_process)
      ChordTransposer.transpose_line(line_to_process, @current_total_semitones)
    else
      line_to_process
    end
  end

  @transposed_text = transposed_lines.join("\n")

  erb :index
end

post '/transpose' do
  redirect '/' unless session[:current_song]

  current_song = session[:current_song]

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

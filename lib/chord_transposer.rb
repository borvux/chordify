# frozen_string_literal: true

# provides functionality for transposing musical chords within a line of text.
module ChordTransposer
  NOTES = %w[A A# B C C# D D# E F F# G G#].freeze
  CHORD_REGEX = /\b([A-G][b#]?(m|maj|min|sus|dim|aug|add)?(\d+)?(M)?)\b/

  FLAT_TO_SHARP = {
    'Ab' => 'G#', 'Bb' => 'A#', 'Cb' => 'B',
    'Db' => 'C#', 'Eb' => 'D#', 'Fb' => 'E',
    'Gb' => 'F#'
  }.freeze

  def self.transpose_chord(chord, semitones)
    return chord if chord.nil? || chord.strip.empty? || semitones.zero?

    match = chord.match(/^([A-G][b#]?)/)
    return chord unless match

    base_note = match[1]
    suffix = chord[base_note.length..]

    normalized_note = FLAT_TO_SHARP[base_note] || base_note

    current_index = NOTES.index(normalized_note)
    return chord unless current_index

    new_index = (current_index + semitones) % NOTES.length

    "#{NOTES[new_index]}#{suffix}"
  end

  def self.transpose_line(line, semitones)
    line.gsub(CHORD_REGEX) do |chord_match|
      transpose_chord(chord_match, semitones)
    end
  end

  def self.chord_line?(line)
    words = line.strip.split(/\s+/)
    return false if words.empty?

    chord_words = words.count { |word| word.match?(CHORD_REGEX) }

    (chord_words.to_f / words.length) > 0.5
  end
end

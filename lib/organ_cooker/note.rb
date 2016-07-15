require 'pry'

##
# Implementation of String class in order to access OrganCooker::Note objects.
class String

  ##
  # Returns a OrganCooker::Note object.
  def to_note
    Note.new(self)
  end
end

##
# Repensents a musical note. This class implement a range class in order to
# manipulate musical notes easily.
# ====Example :
#   r = OrganCooker::Note.new("c1")..OrganCooker::Note.new("a2")
class OrganCooker::Note

  include Comparable

  ##
  # An array of notes letters.
  NOTES = %w(C C# D D# E F F# G G# A A# B)

  ##
  # Letter of the note.
  attr_reader :letter
  ##
  # Octave of the note.
  attr_reader :octave

  ##
  # Initialize a OrganCooker::Note object by +letter+ and +octave+ :
  # [note]  Should be a string
  # ====Example :
  #   OrganCooker::Note.new("a#4")
  def initialize(note)
    @letter = note[/[^-?\d+]+/].upcase
    @octave = note[/-?\d+/].to_i
  end

  ##
  # Returns a hash with key +letter+ && +octave+.
  def info_note
    { letter: @letter, octave: @octave }
  end

  ##
  # Returns a string of next note.
  def next_note
    index  = NOTES.index(@letter) + 1
    octave = @octave
    if index == 12
      index   = 0
      octave += 1
    end
    "#{NOTES[index]}#{octave}"
  end

  ##
  # Returns a string of previous note.
  def prev_note
    index  = NOTES.index(@letter) - 1
    octave = @octave
    if index == -1
      index   = 11
      octave -= 1
    end
    "#{NOTES[index]}#{octave}"
  end

  ##
  # Returns self next note object. Used by Comparable to implement Range object.
  def succ
    OrganCooker::Note.new(self.next_note)
  end

  ##
  # Compares two OrganCooker::Note each other. Used by Comparable to implement
  # Range object. Returns -1 if less than, 0 if equal to or 1 if greater than.
  def <=>(other)
    if NOTES.index(@letter) < NOTES.index(other.letter) && @octave <= other.octave
      return -1
    elsif @octave < other.octave
      return -1
    elsif @letter == other.letter && @octave == other.octave
      return 0
    else
      return 1
    end
  end

  ##
  # Returns note to string.
  def to_s
    "#{inspect}"
  end

  ##
  # Returns a string containing a human-readable representation of object.
  def inspect
    "#{@letter}#{@octave}"
  end
end

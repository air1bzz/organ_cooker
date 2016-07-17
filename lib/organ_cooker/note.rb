require 'pry'

##
# Implementation of Ruby core {http://ruby-doc.org/core-2.3.1/String.html String}
# class in order to access OrganCooker::Note objects.
class String

  ##
  # Converts string to music note class object
  #
  # @return [OrganCooker::Note]
  # @api public
  # @example
  #   n = "a#1".to_note #=> A#1
  #   n.class           #=> OrganCooker::Note
  def to_note
    OrganCooker::Note.new(self)
  end
end

##
# Repensents a music note. This class implement a
# {http://ruby-doc.org/core-2.3.1/Range.html Range} class in order to
# manipulate music notes easily.
# @example
#   r = OrganCooker::Note.new("c1")..OrganCooker::Note.new("a2") #=> C1..C2
#   r.to_a #=> [C1, C#1, D1, D#1, E1, F1, F#1, G1, G#1, A1, A#1, B1, C2]
#   r.include?(OrganCooker::Note.new("g#1")) #=> true
class OrganCooker::Note

  include Comparable

  ##
  # An array of notes letters
  # @return [Array] the twelve music notes
  NOTES = %w(C C# D D# E F F# G G# A A# B)

  ##
  # Gets the letter of the note
  # @api public
  # @return [String] the letter of the note
  # @example
  #   n = OrganCooker::Note.new("a#4")
  #   n.letter #=> "A#"
  attr_reader :letter
  ##
  # Gets the octave of the note
  # @api public
  # @return [Fixnum] the octave of the note
  # @example
  #   n = OrganCooker::Note.new("a#4")
  #   n.octave #=> 4
  attr_reader :octave

  ##
  # Initialize a Note class object by +letter+ and +octave+
  # @param note [String]
  # @example
  #   OrganCooker::Note.new("a#4") #=> A#4
  # @note The note must follow this pattern :
  #   * C, C#, D, D#, E, F, F#, G, G#, A, A#, B
  #   * followed by octave number
  def initialize(note)
    @letter = note[/[^-?\d+]+/].upcase
    @octave = note[/-?\d+/].to_i
  end

  ##
  # Returns the next note
  # @api public
  # @return [String] a string of next note
  # @example
  #   n = OrganCooker::Note.new("g#1") #=> G#1
  #   n.next_note                      #=> "A1"
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
  # Returns the previous note
  # @api public
  # @return [String] a string of previous note
  # @example
  #   n = OrganCooker::Note.new("g#1") #=> G#1
  #   n.prev_note                      #=> "G1"
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
  ##
  # Returns next music note object
  # @api public
  # @return [OrganCooker::Note] the next object
  # @example
  #   n = OrganCooker::Note.new("g#1") #=> G#1
  #   n.succ                           #=> A1
  # @note Used by Ruby core
  #   {http://ruby-doc.org/core-2.3.1/Comparable.html Comparable} module to
  #   implement Range object.
  def succ
    OrganCooker::Note.new(self.next_note)
  end

  ##
  # Compares two music notes each other
  # @api public
  # @return [Fixnum] returns -1 if less than, 0 if equal to, or 1 if greater than.
  # @example
  #   n = OrganCooker::Note.new("g#1")    #=> G#1
  #   n.<=>(OrganCooker::Note.new("c#1")) #=> 1
  # @note Used by Ruby core
  #   {http://ruby-doc.org/core-2.3.1/Comparable.html Comparable} module to
  #   implement Range object.
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
  # Returns the string representation of object
  # @api public
  # @return [String]
  # @example
  #   OrganCooker::Note.new("g#1").to_s #=> "G#1"
  def to_s
    "#{inspect}"
  end

  ##
  # Overrides inspect native method for a human-readable representation of object
  # @api public
  # @return [String]
  # @example Native and modified method
  #   OrganCooker::Note.new("g#1").inspect
  #   #=> #<OrganCooker::Note:0x0055dca5c61470 @letter="G#", @octave=1>
  #   OrganCooker::Note.new("g#1").inspect
  #   #=> G#1
  def inspect
    "#{@letter}#{@octave}"
  end
end

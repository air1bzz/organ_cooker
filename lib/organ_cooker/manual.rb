require_relative 'shared'

# Creates a +manual/keyboard+ object.
class OrganCooker::Manual

  include OrganCooker::Shared

  # Returns the number of notes for a manual/keyboard.
  attr_reader :nb_notes

  # Initialize a OrganCooker::Manual object with these parameters :
  # * a name
  # * the number of notes (default: 61, from C0 to C6)
  # * the first note (default: C0)
  # The notes must follow this pattern :
  # * C C# D D# E F F# G G# A A# B
  # * followed by octave number
  # A4 is the +diapason+ in OrganCooker::Project#diapason).
  def initialize(name, nb_notes="61", first_note="C0")
    @name       = name
    @nb_notes   = nb_notes
    @first_note = first_note
  end
end

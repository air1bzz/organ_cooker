require_relative 'shared'

##
# Represents a +windchest+ for a pipe organ. Not to be confused with the keyboard.
# A windchest can have more music notes than a keyboard.
# Ex : "Grand-Orgue", "Pedal", "Positif"...
class OrganCooker::WindChest

  include OrganCooker::Shared

  # Initialize a windchest object
  # @param name [String] the name of the keyboard (ex: "grand-orgue")
  # @param nb_notes [String, Integer] the number of notes
  # @param first_note [String] the lowest note
  # @example
  #   OrganCooker::WindChest.new("grand-orgue", "56", "C2")
  # @note The first note must follow this pattern :
  #   * a +letter+ C, C#, D, D#, E, F, F#, G, G#, A, A#, B
  #   * followed by +octave+ number
  #   A3 correspond to the 3rd A of a 8 feet rank and is the +diapason+
  def initialize(name, nb_notes="61", first_note="C1")
    @name       = name
    @nb_notes   = nb_notes
    @first_note = first_note
  end
end

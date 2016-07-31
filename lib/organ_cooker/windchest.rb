require_relative 'shared'

##
# Represents a +windchest+ for a pipe organ. Not to be confused with the keyboard.
# A windchest can have more music notes than a keyboard.
# Ex : "Grand-Orgue", "Pedal", "Positif"...
class OrganCooker::WindChest

  ##
  # @overload nb_notes
  #   Gets the current number of notes
  #   @api public
  # @overload nb_notes=(value)
  #   Sets the new number of notes
  #   @api public
  #   @param value [String, Integer] the new number of notes
  # @return [String, Integer] the number of notes
  attr_accessor :nb_notes
  ##
  # @overload first_note
  #   Gets the current lowest note
  #   @api public
  # @overload first_note=(value)
  #   Sets the new lowest note
  #   @api public
  #   @param value [String] the new lowest note
  # @return [String] the lowest note
  attr_accessor :first_note
  ##
  # @overload foot_height
  #   Gets the current height of pipe's foot
  #   @api public
  # @overload foot_height=(value)
  #   Sets the new height of pipe's foot
  #   @api public
  #   @param value [Integer] the new height of pipe's foot
  # @return [Integer] the height of pipe's foot
  attr_accessor :foot_height

  include OrganCooker::Shared

  ##
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
  def initialize(name, nb_notes="61", first_note="C1", foot_height="200")
    @name        = name
    @nb_notes    = nb_notes
    @first_note  = first_note
    @foot_height = foot_height
  end

  ##
  # Finds the last note of the windchest
  # @api public
  # @return [OrganCooker::Note] the last note
  # @example
  #   n = OrganCooker::WindChest.new("grand-orgue", "56", "C1")
  #   n.last_note #=> G5
  def last_note
    @first_note.to_note.find_last_note(@nb_notes)
  end
end

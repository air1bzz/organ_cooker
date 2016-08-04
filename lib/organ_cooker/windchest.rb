require_relative 'shared'

##
# Represents a +windchest+ for a pipe organ. Not to be confused with the keyboard.
# A windchest can have more music notes than a keyboard.
# Ex : "Grand-Orgue", "Pedal", "Positif"...
class OrganCooker::WindChest

  ##
  # The +name+ of the windchest
  # @overload name
  #   Gets the current name
  #   @api public
  # @overload name=(value)
  #   Sets the new name
  #   @api public
  #   @param value [String] the new name
  # @return [string]
  attr_accessor :name

  ##
  # Gets the current +number of notes+
  # @overload nb_notes
  #   Gets the current number of notes
  #   @api public
  # @overload nb_notes=(value)
  #   Sets the new number of notes
  #   @api public
  #   @param value [Integer] the new number of notes
  # @return [Integer] the number of notes
  attr_accessor :nb_notes

  ##
  # Gets the current +lowest note+
  # @overload first_note
  #   Gets the current lowest note
  #   @api public
  # @overload first_note=(value)
  #   Sets the new lowest note
  #   @api public
  #   @param value [OrganCooker::Note] the new lowest note
  # @return [OrganCooker::Note] the lowest note
  attr_accessor :first_note

  ##
  # Gets the current +height+ of pipe's +foot+
  # @overload foot_height
  #   Gets the current foot height
  #   @api public
  # @overload foot_height=(value)
  #   Sets the new foot height
  #   @api public
  #   @param value [Integer] the new foot height
  # @return [Integer] the foot height
  attr_accessor :foot_height

  ##
  # Initialize a +windchest+ object
  # @param name [String] the name of the keyboard (ex: "grand-orgue")
  # @param nb_notes [Integer] the number of notes
  # @param first_note [OrganCooker::Note] the lowest note
  # @param foot_height [Integer] the pipe's foot height
  # @example
  #   w = OrganCooker::WindChest.new("grand-orgue", 48, "C1".to_note, 220)
  def initialize(name, nb_notes=61, first_note=OrganCooker::Note.new("C1"), foot_height=200)
    @name        = name
    @nb_notes    = nb_notes
    @first_note  = first_note
    @foot_height = foot_height
  end

  ##
  # Finds the +last note+ of the windchest
  # @api public
  # @return [OrganCooker::Note] the last note
  # @example
  #   w.last_note #=> B4
  def last_note
    @first_note.find_last_note(@nb_notes)
  end
end

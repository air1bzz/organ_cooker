require_relative 'shared'

# Represents a +windchest+ for a pipe organ.
# Ex : "Grand-Orgue", "Pedal", "Positif"...
class OrganCooker::WindChest

  include OrganCooker::Shared

  # Initialize a OrganCooker::WindChest object with these parameters :
  # * a name (ex: "grand-orgue")
  # * the number of notes (default: "61", from C1 to C6)
  # * the first note (default: "C1")
  # Example :
  #   OrganCooker::WindChest.new("grand-orgue", "56", "C2")
  # The first note must follow this pattern :
  # * C, C#, D, D#, E, F, F#, G, G#, A, A#, B
  # * followed by octave number
  # A3 is the +diapason+ in OrganCooker::Project#diapason.
  def initialize(name, nb_notes="61", first_note="C1")
    @name       = name
    @nb_notes   = nb_notes
    @first_note = first_note
  end
end

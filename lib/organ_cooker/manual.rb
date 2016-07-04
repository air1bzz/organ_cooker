require_relative 'shared'

##
# Creates a "Manual/Keyboard" object.
class OrganCooker::Manual

  include Shared

  ##
  # Set the number of notes for a manual.
  attr_reader :nb_notes

  ##
  # Initialization.
  def initialize(name, nb_notes)
    @name     = name
    @nb_notes = nb_notes
  end
end

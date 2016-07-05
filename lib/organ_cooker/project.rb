require_relative 'shared'

# Creates a "Project" object.
class OrganCooker::Project

  include Shared

  # Returns "diapason" value.
  attr_reader :diapason

  # Initialization.
  def initialize(name, temperature, diapason)
    @name        = name
    @temperature = temperature
    @diapason    = diapason
  end

  # Work out sound speed according to temperature.
  def sound_speed
    331.5 + 0.607 * @temperature.to_f #source wikipedia
  end
end

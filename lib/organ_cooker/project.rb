require_relative 'shared'

# Represent a organ +project+ with global parameters :
# * a name
# * the temperature (in Celsius)
# * the diapason (in Hertz)
#
# These parameters will be used to create organ +ranks+.
class OrganCooker::Project

  include Shared

  # Returns +diapason+ value.
  attr_reader :diapason

  # Initialize a OrganCooker::Project object, +temperature+ parameter is used in
  # #sound_speed method.
  def initialize(name, temperature, diapason)
    @name        = name
    @temperature = temperature
    @diapason    = diapason
  end

  # Work out sound speed according to +temperature+.
  def sound_speed
    331.5 + 0.607 * @temperature.to_f #source wikipedia
  end
end

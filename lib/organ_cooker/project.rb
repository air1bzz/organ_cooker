require_relative 'shared'

# Represent a organ +project+ with global parameters.
# These parameters will be used to create organ +ranks+.
class OrganCooker::Project

  include OrganCooker::Shared

  # Returns +diapason+ value.
  attr_reader :diapason

  # Initialize a OrganCooker::Project object with these parameters :
  # * a name
  # * the temperature (in Celsius, default: 18)
  # * the diapason (in Hertz, default: 440)
  def initialize(name, temperature="18", diapason="440")
    @name        = name
    @temperature = temperature
    @diapason    = diapason
  end

  # Work out speed of sound according to +temperature+.
  # source [Wikipedia](https://en.wikipedia.org/wiki/Speed_of_sound)
  def speed_of_sound
    # source Wikipedia (https://en.wikipedia.org/wiki/Speed_of_sound)
    331.5 + 0.607 * @temperature.to_f
  end
end

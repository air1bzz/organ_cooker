require_relative 'shared'

##
# Represents an organ +project+ with global parameters.
# These parameters will be used to create organ +ranks+.
class OrganCooker::Project

  include OrganCooker::Shared

  ##
  # Initialize a +project+ object
  # @param name [String] the name of the project (quite often a town name)
  # @param temperature [String, Numeric] the temperature (in Celsius)
  # @param diapason [String, Numeric] the diapason (in Hertz)
  # @example
  #   OrganCooker::Project.new("mantes-la-jolie", "15", "435")
  def initialize(name, temperature="18", diapason="440")
    @name        = name
    @temperature = temperature
    @diapason    = diapason
  end

  ##
  # Work out speed of sound according to +temperature+
  # @api public
  # @return [Float] the speed of sound
  # @example
  #   p = OrganCooker::Project.new("mantes-la-jolie", "15", "435")
  #   p.speed_of_sound #=> 340.605
  # @note Source {Wikipedia}[https://en.wikipedia.org/wiki/Speed_of_sound]
  def speed_of_sound
    331.5 + 0.607 * @temperature.to_f
  end
end

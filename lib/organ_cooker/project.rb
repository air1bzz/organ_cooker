require_relative 'shared'

##
# Represents an organ +project+ with global parameters.
# These parameters will be used to create organ +ranks+.
class OrganCooker::Project

  include OrganCooker::Shared

  ##
  # Initialize an OrganCooker::Project object with these parameters :
  # [name]         a name (quite often a town name)
  # [temperature]  the temperature (in Celsius, default: "18")
  # [diapason]     the diapason (in Hertz, default: "440")
  # ====Example :
  #   OrganCooker::Project.new("mantes-la-jolie", "15", "435")
  def initialize(name, temperature="18", diapason="440")
    @name        = name
    @temperature = temperature
    @diapason    = diapason
  end

  ##
  # Work out speed of sound according to +temperature+.
  # Source {Wikipedia}[https://en.wikipedia.org/wiki/Speed_of_sound]
  def speed_of_sound
    331.5 + 0.607 * @temperature.to_f
  end
end

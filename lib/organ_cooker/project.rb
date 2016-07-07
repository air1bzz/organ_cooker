require_relative 'shared'

# Represents a organ +project+ with global parameters.
# These parameters will be used to create organ +ranks+.
# See :
# * OrganCooker::RankTypeFlute
# * OrganCooker::RankTypeBourdon
# * OrganCooker::RankTypeMixtures
# * OrganCooker::RankTypeCornet
class OrganCooker::Project

  include OrganCooker::Shared

  # Returns +diapason+ value.
  attr_reader :diapason

  # Initialize a OrganCooker::Project object with these parameters :
  # * a name (quite often a town name)
  # * the temperature (in Celsius, default: 18)
  # * the diapason (in Hertz, default: 440)
  # Example :
  #   OrganCooker::Project.new("mantes-la-jolie", temperature="15", diapason="435")
  def initialize(name, temperature="18", diapason="440")
    @name        = name
    @temperature = temperature
    @diapason    = diapason
  end

  # Work out speed of sound according to +temperature+.
  # Source Wikipedia (https://en.wikipedia.org/wiki/Speed_of_sound)
  def speed_of_sound
    331.5 + 0.607 * @temperature.to_f
  end
end

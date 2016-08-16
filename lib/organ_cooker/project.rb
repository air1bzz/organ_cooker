module OrganCooker
  ##
  # Represents an organ +project+ with global parameters.
  # These parameters will be used to create organ +ranks+.
  class Project
    ##
    # The +name+ of the project
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
    # The +temperature+ of the project
    # @overload temperature
    #   Gets the current temperature
    #   @api public
    # @overload temperature=(value)
    #   Sets the new temperature
    #   @api public
    #   @param value [Float, Integer] the new temperature
    # @return [Float, Integer] the temperature
    attr_accessor :temperature

    ##
    # The +diapason+ of the project
    # @overload diapason
    #   Gets the current diapason
    #   @api public
    # @overload diapason=(value)
    #   Sets the new diapason
    #   @api public
    #   @param value [Float, Integer] the new diapason
    # @return [Float, Integer] the diapason
    attr_accessor :diapason

    ##
    # Initialize a +project+ object
    # @param name [String] the name of the project (quite often a town name)
    # @param temperature [Float, Integer] the temperature (in Celsius)
    # @param diapason [Float, Integer] the diapason (in Hertz)
    # @example
    #   p = OrganCooker::Project.new("new-york", 15, 435)
    #   #=> #<OrganCooker::Project:0x40eafb0 @diapason=435, @name="new-york", @temperature=15>
    def initialize(name, temperature = 18, diapason = 440)
      @name        = name
      @temperature = temperature
      @diapason    = diapason
    end

    ##
    # Work out +speed of sound+ according to +temperature+
    # @api public
    # @return [Float] the speed of sound
    # @example
    #   p.speed_of_sound #=> 340.605
    # @note Source {Wikipedia}[https://en.wikipedia.org/wiki/Speed_of_sound]
    def speed_of_sound
      331.5 + 0.607 * @temperature
    end
  end
end

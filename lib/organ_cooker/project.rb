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
    attr_reader :name

    ##
    # The +temperature+ of the project
    # @overload temperature
    #   Gets the current temperature
    #   @api public
    # @overload temperature=(value)
    #   Sets the new temperature
    #   @api public
    #   @param value [Numeric] the new temperature
    # @return [Numeric] the temperature
    attr_reader :temperature

    ##
    # The +diapason+ of the project
    # @overload diapason
    #   Gets the current diapason
    #   @api public
    # @overload diapason=(value)
    #   Sets the new diapason
    #   @api public
    #   @param value [Numeric] the new diapason
    # @return [Numeric] the diapason
    attr_reader :diapason

    def name=(name)
      raise 'The name must be a string.' unless name.is_a?(String)
      raise 'The name is required.' if name.strip.empty?
      @name = name.strip.gsub(/[[:alpha:]]+/, &:capitalize)
    end

    def temperature=(temp)
      raise 'The temperature must be a number.' unless temp.is_a?(Numeric)
      raise 'The temperature must be beetween -20°C & 40°C' if temp < -20 || temp > 40
      @temperature = temp
    end

    def diapason=(diap)
      raise 'The diapason must be a number.' unless diap.is_a?(Numeric)
      raise 'The diapason must be positive' if diap.zero? || diap.negative?
      @diapason = diap
    end

    ##
    # Initialize a +project+ object
    # @param name [String] the name of the project (quite often a town name)
    # @param temperature [Numeric] the temperature (in Celsius)
    # @param diapason [Numeric] the diapason (in Hertz)
    # @example
    #   p = OrganCooker::Project.new("new-york", 15, 435)
    def initialize(name, temperature = 18, diapason = 440)
      self.name        = name
      self.temperature = temperature
      self.diapason    = diapason
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

    ##
    # Displays a +string representation+ of the object
    # @api public
    # @return [String] a string representation
    # @example
    #   p.to_s #=> "Project: New-York"
    def to_s
      "Project: #{name}"
    end
  end
end

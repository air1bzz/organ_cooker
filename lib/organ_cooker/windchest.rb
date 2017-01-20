require 'organ_cooker/shared'

module OrganCooker
  ##
  # Represents a +windchest+ for a pipe organ. Not to be confused with the
  # keyboard. A windchest can have more music notes than a keyboard.
  # Ex : "Grand-Orgue", "Pedal", "Positif"...
  class WindChest
    include Shared
    ##
    # The +name+ of the windchest
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
    # The +number of notes+
    # @overload nb_notes
    #   Gets the current number of notes
    #   @api public
    # @overload nb_notes=(value)
    #   Sets the new number of notes
    #   @api public
    #   @param value [Fixnum] the new number of notes
    # @return [Fixnum] the number of notes
    attr_reader :nb_notes

    ##
    # The +lowest note+
    # @overload first_note
    #   Gets the current lowest note
    #   @api public
    # @overload first_note=(value)
    #   Sets the new lowest note
    #   @api public
    #   @param value [OrganCooker::Note] the new lowest note
    # @return [OrganCooker::Note] the lowest note
    attr_reader :first_note

    ##
    # The +height+ of pipe's +foot+
    # @overload foot_height
    #   Gets the current foot height
    #   @api public
    # @overload foot_height=(value)
    #   Sets the new foot height
    #   @api public
    #   @param value [Numeric] the new foot height
    # @return [Numeric] the foot height
    attr_reader :foot_height

    def nb_notes=(nb_notes)
      raise ArgumentError, 'Number of notes must be an integer' unless nb_notes.is_a? Fixnum
      raise ArgumentError, 'Number of notes must be positive' if nb_notes.zero? || nb_notes.negative?
      @nb_notes = nb_notes
    end

    def first_note=(note)
      raise ArgumentError, "#{note} is not a OrganCooker::Note object" unless note.is_a? Note
      @first_note = note
    end

    def foot_height=(height)
      raise ArgumentError, 'The diapason must be a number.' unless height.is_a? Numeric
      raise ArgumentError, 'The height must be positive' if height.zero? || height.negative?
      @foot_height = height
    end

    ##
    # Initialize a +windchest+ object
    # @param name [String] the name of the keyboard (ex: "grand-orgue")
    # @param nb_notes [Fixnum] the number of notes
    # @param first_note [OrganCooker::Note] the lowest note
    # @param foot_height [Numeric] the pipe's foot height
    # @example
    #   w = OrganCooker::WindChest.new("grand-orgue", 48, "C1".to_note, 220)
    def initialize(name,
                   nb_notes = 61,
                   first_note = OrganCooker::Note.new('C1'),
                   foot_height = 200)
      self.name        = name
      self.nb_notes    = nb_notes
      self.first_note  = first_note
      self.foot_height = foot_height
    end

    ##
    # Finds the +last note+ of the windchest
    # @api public
    # @return [OrganCooker::Note] the last note
    # @example
    #   w.last_note #=> B4
    def last_note
      @first_note.find_last_note(@nb_notes)
    end

    ##
    # Displays a +string representation+ of the object
    # @api public
    # @return [String] a string representation
    # @example
    #   p.to_s #=> "WindChest: Grand-Orgue"
    def to_s
      "== Windchest: #{@name} ==\nfrom #{@first_note.to_s} to #{self.last_note.to_s} (#{@nb_notes} notes)"
    end
  end
end

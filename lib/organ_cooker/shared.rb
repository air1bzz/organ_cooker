module OrganCooker
  ##
  # This module is shared by different classes.
  module Shared

    def name=(name)
      raise ArgumentError, 'The name must be a string.' unless name.is_a? String
      raise ArgumentError, 'The name is required.' if name.strip.empty?
      @name = name.strip.gsub(/[[:alpha:]]+/, &:capitalize)
    end

    # def name
    # name = @name.gsub(/[[:alpha:]]+/) { |word| word.capitalize }
    #
    # case self
    # when OrganCooker::RankTypeFlute, OrganCooker::RankTypeBourdon
    #   if @height.include? "/"
    #     numbers = digits_scan(@height)
    #     "#{name} #{numbers[0]}' #{numbers[1]}/#{numbers[2]}"
    #   else
    #     "#{name} #{@height}'"
    #   end
    # when OrganCooker::RankTypeMixtures, OrganCooker::RankTypeCornet
    #   rows = @nb_rows.scan(/\d+/).map { |row| row = row.to_i.to_roman.to_s }.join('-')
    #   "#{name} #{rows}"
    # else
    #   name
    # end

    private

    ##
    # Returns a +float height+ for a fraction entry (ex: 2'2/3)
    # @api private
    # @return [Float]
    # @param height [String]
    # @example
    #   height_decimal("2'2/3") #=> 2.6666666666666665
    def height_decimal(height)
      if height.include?('/')
        numbers = height.scan(/\d+/).map(&:to_f)
        if numbers.size == 3
          numbers[0] + numbers[1] / numbers[2]
        else
          numbers[0] / numbers[1]
        end
      else
        height.to_f
      end
    end
  end
end

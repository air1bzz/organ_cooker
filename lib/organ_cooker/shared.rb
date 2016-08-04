##
# This module is shared by different classes.
module OrganCooker::Shared

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
      numbers = height.scan(/\d+/).map { |i| i.to_f }
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

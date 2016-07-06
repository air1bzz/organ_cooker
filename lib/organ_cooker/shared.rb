# This module is shared with :
# * OrganCooker::Manual
# * OrganCooker::Project
# * OrganCooker::Rank
module OrganCooker::Shared

  # Returns object name with optionally feet height or number of rows.
  def name
    name = @name.gsub(/[[:alpha:]]+/) { |word| word.capitalize }

    case self
    when OrganCooker::RankTypeFlute, OrganCooker::RankTypeBourdon
      if @height.include? "/"
        numbers = digits_scan(@height)
        "#{name} #{numbers[0]}' #{numbers[1]}/#{numbers[2]}"
      else
        "#{name} #{@height}'"
      end
    when OrganCooker::RankTypeMixtures, OrganCooker::RankTypeCornet
      rows = @nb_rows.scan(/\d+/).map { |row| row = row.to_i.to_roman.to_s }.join('-')
      "#{name} #{rows}"
    else
      name
    end
  end

  private

  # Returns an array of numbers.
  def digits_scan(string)
    string.scan(/[[:digit:]]+/)
  end
end

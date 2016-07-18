##
# This module is shared by different classes.
module OrganCooker::Shared

  ##
  # Returns object name
  # @api public
  # @return [String] the name of object
  # @example
  #   p = OrganCooker::Project.new("mantes-la-jolie", "15", "435")
  #   n.name #=> "Mantes-La-Jolie"
  def name
    name = @name.gsub(/[[:alpha:]]+/) { |word| word.capitalize }

    case self
    when OrganCooker::RankTypeMixtures, OrganCooker::RankTypeCornet
      rows = @nb_rows.scan(/\d+/).map { |row| row = row.to_i.to_roman.to_s }.join('-')
      "#{name} #{rows}"
    else
      name
    end
  end
end

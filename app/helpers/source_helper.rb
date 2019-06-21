module SourceHelper
	def general_source_type
		source_value = {}
		GeneralSource.all.each do |gs|
			source_value[gs.id] = "#{gs.name} (#{gs.general_source_type.upcase})"
		end
		source_value
	end
end

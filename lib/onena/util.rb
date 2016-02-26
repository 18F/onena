require 'text'

module Onena
	module Util
		def self.matches(tock_list: nil, float_list: nil)
			white = Text::WhiteSimilarity.new
			# Remove exact matches
			tock = tock_list - float_list
			float = float_list - tock_list
			matches = tock.map do |tock_item|
				float.map do |float_item|
					{
						:float => float_item,
						:tock => tock_item,
						:distance => Text::Levenshtein.distance(float_item, tock_item),
						:similarity => white.similarity(float_item, tock_item)
					}
				end
			end
			matches.flatten.compact
		end

	end
end

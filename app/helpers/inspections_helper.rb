module InspectionsHelper
	def current_inspection
		# stub for now, since I have no idea how to make it in ruby
		@current_inspection = Inspection.first
	end

	def current_inspection?(inspection)
		inspection == current_inspection
	end

	def current_inspection=(inspection)
		@current_inspection = inspection
	end
end

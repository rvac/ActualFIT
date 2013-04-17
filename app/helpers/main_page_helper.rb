module MainPageHelper
	def dropdown_inspection_stub_for(inspection = nil)
		html = '<li><a href="#">Inspection 1</a></li>
				<li><a href="#">Inspection 2</a></li>
				<li><a href="#">Inspection 3</a></li>
				<li><a href="#">Inspection 4</a></li>
				<li><a href="#">Turbo-Inspector</a></li>'

		return html.html_safe
	end

	def dropdown_roles_stub_for(user = nil, role = nil)
		html = '<li><a href="#">Author</a></li>
				<li><a href="#">Moderator</a></li>
				<li><a href="#">Superviser</a></li>
				<li><a href="#">Inspector</a></li>'

		return html.html_safe
	end
end

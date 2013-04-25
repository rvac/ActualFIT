module RemarksHelper
	def remarksActionPanel(remark)

		html = '<div class="ACTRActionPanel">'						
		html << link_to(image_tag('icon_32/delete_32.png', alt:"stub"), remark, confirm: "Are you sure?", method: :delete, remote: true, class: "ActionElement")
		html << '</div>'

		return html.html_safe
	end
end

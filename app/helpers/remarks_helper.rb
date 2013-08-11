module RemarksHelper
	def remarksActionPanel(remark)

		html = '<div class="ACTRActionPanel">'						
		html << link_to(image_tag('icon_16/delete_16.png', alt:"delete"), inspection_remark_path(remark.inspection_id,remark.id), method: :delete, remote: true, class: "ActionElement")
		html << '</div>'

		return html.html_safe
	end
end

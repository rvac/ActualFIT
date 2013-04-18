module ArtifactsHelper
	def artifactActionPanel_stub
		
		actionPanel_content = '<div class="ArtifactActionPanel">'
		actionPanel_content << image_tag('icon_32/pencil_32.png', alt:"stub", class: "ActionElement")
		actionPanel_content << image_tag('icon_32/user_32.png', alt:"stub", class: "ActionElement")											
		actionPanel_content << image_tag('icon_32/save_32.png', alt:"stub", class: "ActionElement")										
		actionPanel_content << image_tag('icon_32/delete_32.png', alt:"stub", class: "ActionElement")	
		actionPanel_content << '</div>'

		actionPanel_content.html_safe
	end
end

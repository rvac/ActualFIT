module ArtifactsHelper
	def artifactActionPanel(artifact)
		
		actionPanel_content = '<div class="ArtifactActionPanel">'
		actionPanel_content << link_to(image_tag('icon_32/pencil_32.png', alt:"stub"), '#', class: "ActionElement")										
		actionPanel_content << link_to(image_tag('icon_32/save_32.png', alt:"save on disk"), artifact, class: "ActionElement")										
		actionPanel_content << link_to(image_tag('icon_32/delete_32.png', alt:"stub"), artifact, confirm: "Are you sure?", method: :delete, class: "ActionElement")	
		actionPanel_content << '</div>'

		actionPanel_content.html_safe
	end
end

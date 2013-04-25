module ArtifactsHelper
	def artifactActionPanel(artifact)
		
		actionPanel_content = '<div class="ArtifactActionPanel">'
		actionPanel_content << link_to(image_tag('icon_32/pencil_32.png', alt:"edit"), edit_artifact_path(artifact), class: "ActionElement")										
		actionPanel_content << link_to(image_tag('icon_32/save_32.png', alt:"save on disk"), artifact, class: "ActionElement")										
		actionPanel_content << link_to(image_tag('icon_32/delete_32.png', alt:"delete"), artifact, confirm: "Are you sure?", method: :delete, class: "ActionElement")	
		actionPanel_content << '</div>'

		actionPanel_content.html_safe
	end

	def artifact_icon(artifact)
		if artifact.filename[/\.((docx)|(doc)|(rtf)|(txt)|(wpd)|(wps)|(log)|(msg)|(odt)|(fodt)|(pages)|(tex))\z/i]
			return image_tag('icon_32/text.png', alt:"text-file")
		end
		if artifact.filename[/\.(pdf)\z/i]
			return image_tag('icon_32/pdf.png', alt:"pdf")
		end
		if artifact.filename[/\.((xls)|(xlsx)|(xlr)|(csv)|(ods)|(fods))\z/i]
			return image_tag('icon_32/spreadsheet.png', alt:"spreadsheets-file")
		end
		if artifact.filename[/\.((ppt)|(pptx)|(odp)|(fodp))\z/i]
			return image_tag('icon_32/presentation.png', alt:"presentataion-file")
		end
		if artifact.filename[/\.((png)|(jpg)|(gif)|(tiff)|(bmp)|(jpeg))\z/i]		
			return image_tag('icon_32/graphics.png', alt:"graphics-file")		
		end
		if artifact.filename[/\.((zip)|(rar)|(tar)|(bzip)|(gzip)|(7z))\z/i]		
			return image_tag('icon_32/archive.png', alt:"archive-file")			
		end
		if artifact.filename[/\.((png)|(jpg)|(gif)|(tiff)|(bmp)|(jpeg))\z/i]	
			return image_tag('icon_32/graphics.png', alt:"graphics-file")		
		end

	end
end

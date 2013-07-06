module ArtifactsHelper
	def artifactActionPanel(artifact)
		
		actionPanel_content = '<div class="ArtifactActionPanel">'

    if can? :edit, artifact
		actionPanel_content << link_to(image_tag('icon_32/pencil_32.png', alt:"edit"), 
			edit_artifact_path(artifact), class: "ActionElement")
    end

    if can? :read, artifact
		actionPanel_content << link_to(image_tag('icon_32/save_32.png', alt:"save on disk"), 
			artifact, class: "ActionElement")
    end

    if can? :destroy, artifact
		actionPanel_content << link_to(image_tag('icon_32/delete_32.png', alt:"delete"), 
			artifact, confirm: "Are you sure?", method: :delete, class: "ActionElement")
    end
		actionPanel_content << '</div>'

		actionPanel_content.html_safe
	end

	def artifact_icon(artifact)
    if artifact.nil?
      return ""
    end
		if artifact.filename[/\.((docx)|(doc))\z/i]
			return image_tag('Free-file-icons-master/32px/doc.png', alt:"text-file", class: "ArtifactIcon")
		end
		if artifact.filename[/\.(pdf)\z/i]
			return image_tag('Free-file-icons-master/32px/pdf.png', alt:"pdf", class: "ArtifactIcon")
		end
		if artifact.filename[/\.(xls)\z/i]
			return image_tag('Free-file-icons-master/32px/xls.png', alt:"xls-file", class: "ArtifactIcon")
		end
		if artifact.filename[/\.(xlsx)\z/i]
			return image_tag('Free-file-icons-master/32px/xlsx.png', alt:"xlsx-file", class: "ArtifactIcon")
		end
		if artifact.filename[/\.((ppt)|(pptx))\z/i]
			return image_tag('Free-file-icons-master/32px/ppt.png', alt:"presentataion-file", class: "ArtifactIcon")
		end
		if artifact.filename[/\.(png)\z/i]		
			return image_tag('Free-file-icons-master/32px/png.png', alt:"graphics-file", class: "ArtifactIcon")	
		end
		if artifact.filename[/\.((zip)|(rar)|(tar)|(bzip)|(gzip)|(7z))\z/i]		
			return image_tag('Free-file-icons-master/32px/zip.png', alt:"archive-file", class: "ArtifactIcon")		
		end
		if artifact.filename[/\.(xml)\z/i]	
			return image_tag('Free-file-icons-master/32px/xml.png', alt:"xml-file", class: "ArtifactIcon")	
		end

	end
end

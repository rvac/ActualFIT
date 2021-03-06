module InspectionsHelper
	#def current_inspection
	#	# stub for now, since I have no idea how to make it in ruby
	#	@current_inspection = Inspection.first #find(params[:id])
	#end
  #
	#def current_inspection?(inspection)
	#	inspection == current_inspection
	#end
  #
	#def current_inspection=(inspection)
	#	@current_inspection = inspection
	#end

  #def inspection_helper_message(user, inspection)
  #  message = []
  #  name = user.name.split(' ').first
  #  status = inspection.status
  #  roles = current_user.roles.map {|r| r.name if r.resource_id == inspection.id }
  #  roles.each do |role|
  #    case status
  #      when 'setup'
  #        case role
  #          when 'author'
  #            message << "#{name}, upload one or more artifacts for review, make a short comment on key aspects of the artifact"
  #            #return
  #          when 'moderator'
  #            message <<  "#{name}, set up deadlines, times and location of the review, upload guidelines if necessary, then change inspection status to upload"
  #            #return
  #          when 'inspector'
  #            message <<  "#{name}, wait until artifacts are uploaded and deadlines are settled"
  #            #return
  #          else
  #            return message
  #        end
  #      when 'upload'
  #        case role
  #          when 'author'
  #            message <<  "#{name}, if you haven't done it before upload one or more artifacts for review, make a short comment on key aspects of the artifact"
  #            #return
  #          when 'moderator'
  #            message <<  "#{name}, check that uploaded artifacts satisfy requirements, delete inappropriate artifacts.Change status to Prepare"
  #            #return
  #          when 'inspector'
  #            message <<  "#{name}, wait until artifacts are uploaded and deadlines are settled"
  #            #return
  #          else
  #            return message
  #        end
  #      when 'prepare'
  #        case role
  #          when 'author'
  #            message <<  "#{name}, inspect artifacts informally to be prepared for the remarks"
  #            #return
  #          when 'moderator'
  #            message <<  "#{name}, ensure that all inspectors contributed to the inspection. Change status to Inspection"
  #            #return
  #          when 'inspector'
  #            message <<  "#{name}, download the artifacts and inspect them according to the guideline, create/upload your remarks"
  #            #return
  #          else
  #            return message
  #        end
  #      when 'inspection'
  #        case role
  #          when 'author'
  #            message <<  "#{name}, read artifact aloud, respond to remarks made by inspectors"
  #            #return
  #          when 'moderator'
  #            message <<  "#{name}, after the meeting change status to Rework"
  #            #return
  #          when 'inspector'
  #            message <<  "#{name}, listen to the author during artifact reading, negotiate on remarks"
  #            #return
  #          else
  #            return message
  #        end
  #      when 'rework'
  #        case role
  #          when 'author'
  #            message <<  "#{name}, rework on the artifacts according to the remarks. Upload reworked artifacts or edit existing ones"
  #            #return
  #          when 'moderator'
  #            message <<  "#{name}, ensure that the author uploaded reworked artifacts and all issues are addressed. Change status to Finished"
  #            #return
  #          when 'inspector'
  #            message <<  "#{name}, thank you for participation in the inspection"
  #            #return
  #          else
  #            return message
  #        end
  #      when 'finished'
  #        case role
  #          when 'author'
  #            message <<  "#{name}, thank you for participation in the inspection"
  #          when 'moderator'
  #            message <<  "#{name}, thank you for participation in the inspection"
  #          when 'inspector'
  #            message <<  "#{name}, thank you for participation in the inspection"
  #          else
  #            return message
  #        end
  #      else
  #        return message
  #    end
  #  end     #end of each
  #  message
  #end
end

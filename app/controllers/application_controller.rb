class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_back_or main_app.root_url
  end

  def handle_unverified_request
  	sign_out
  	super
  end

  protected
    def current_inspection
      cur_insp = Inspection.find(cookies[:current_inspection_id])
      return cur_insp if !cur_insp.nil?

      return current_user.inspections.first

        #there are no inspections bound to the user.

    rescue ActiveRecord::RecordNotFound
      puts "Oops, old cookies, something was deleted" # do a smart stuff here, some message or better handle it other way
    end

    def current_inspection= (inspection)
       # add check up if inspection is a correct instance if Inspection.class
       cookies[:current_inspection_id] = inspection.id
    end
end

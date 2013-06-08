class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  def handle_unverified_request
  	sign_out
  	super
  end

  protected
    def current_inspection
      Inspection.find(cookies[:current_inspection_id])
    end

    def current_inspection= (inspection)
       # add check up if inspection is a correct instance if Inpection.class
       cookies[:current_inspection_id] = inspection.id
    end
end

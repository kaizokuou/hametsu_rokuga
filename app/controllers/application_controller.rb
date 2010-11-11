class ApplicationController < ActionController::Base
  require "zlib"
  
  protect_from_forgery
  def authorize
    begin
    Entity.find session[:login_id]
    rescue
      redirect_to :controller => :home, :action => :sessions
    end
  end

  def response_save_test
  end
end

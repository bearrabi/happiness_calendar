class CalendarsController < ApplicationController
  before_action :move_to_signin, except: :index
  
  def index
    
  end
  
  private 
  def move_to_signin
    redirect_to new_user_session_path unless user_signed_in?
  end
end

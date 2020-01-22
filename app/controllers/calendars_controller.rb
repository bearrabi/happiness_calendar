class CalendarsController < ApplicationController
  before_action :move_to_signin, except: :index
  
  def index
    @dates = Time.zone.now
    #@dates = {year: Time.zone.now.year, month: Time.zone.now.month}
    #@timezone = Time.zone.now
    @messages = ""
  end
  
  def change
    @dates = {year: params[:year], month: params[:month]}  #ここはindexと同じように修正が必要
    @messages = ""
  end
  
  private 
  def move_to_signin
    redirect_to new_user_session_path unless user_signed_in?
  end
end

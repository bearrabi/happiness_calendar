class MessagesController < ApplicationController
  
  def index
  end
  
  ##単一メッセージの情報を表示
  def show
  end
  
  def new
    @messages = nil
    @dateinfo = {"year": params[:year], "month": params[:month], "day": params[:day] }
    @page_title = "New message"
  end
  
  def edit
    @message = Message.find(params[:id])
    @dateinfo = {"year": message.date.year, "month": message.date.month, "day": message.date.day }
    @page_tilte = "Edit message"
  end
  
  def create
    dayinfo = Day.find_or_create_by(date: Time.local(params[:year].to_i, params[:month].to_i, params[:day].to_i), user_id: current_user.id)
  end
  
  ##特定ユーザーかつ、特定の日付のメッセージリストを表示
  def show_parts
    date = Time.local(params[:year].to_i, params[:month].to_i, params[:day].to_i)
    @messages = Message.where(date: date, user_id: current_user.id)
  end
  
  ##特定のユーザーのメッセージ全てを表示
  def show_all
    @messages = Message.where(user_id: current_user.id)
  end
  
  def message_params
    params.permit[:to_name, :to_email, :mail_title, :mail_contents, :user_id, :day_id]
  end
  def date_params
    params.permit[:year, :month, :day]
  end
end

class MessagesController < ApplicationController
  
  def index
  end
  
  ##単一メッセージの情報を表示
  def show
  end
  
  def new
    @messages = {"to_name": "", "to_email": "", "title": "", "contents": "" }
    @dateinfo = {"year": params[:year], "month": params[:month], "day": params[:day] }
    @page_title = "New message"
  end
  
  def edit
    message = Message.find(params[:id])
    @messages = {"to_name": message.to_name, "to_email": message.to_email, "title": message.title, "contents": message.contents }
    @dateinfo = {"year": message.date.year, "month": message.date.month, "day": message.date.day }
    @page_tilte = "Edit message"
  end
  
  def create
    date = Time.local(date_params[:year].to_i, date_params[:month].to_i, date_params[:day].to_i)
    dayinfo = Day.find_or_create_by(date: date, user_id: current_user.id)
    Message.find_or_create_by(to_name: message_params[:to_name], to_email: message_params[:to_email], title: message_params[:mail_title], contents: message_params[:mail_contents], day_id: dayinfo.id, user_id: current_user.id)
    redirect_to "messages_all/#{current_user.id}"
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
    params.permit(:to_name, :to_email, :mail_title, :mail_contents, :user_id)
  end
  
  def date_params
    params.permit(:day_id, :year, :month, :day)
  end
end

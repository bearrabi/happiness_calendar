class MessagesController < ApplicationController
  
  def index
  end
  
  ##単一メッセージの情報を表示
  def show
  end
  
  def new
  end
  
  def create
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
    params.permit[:to_name, :to_email, :title, :contents, :user_id, :day_id]
  end
end

class CalendarsController < ApplicationController
  before_action :move_to_signin, except: :index
  
  def index
    @dates = Time.zone.now
    @messages = ""
  end
  
  def change
    @dates = Time.local(params[:year].to_i,params[:month].to_i)   #ここはindexと同じように修正が必要
    @calendars = get_calendar(@dates)
    @messages = ""
  end
  
  private 
  def move_to_signin
    redirect_to new_user_session_path unless user_signed_in?
  end
  
  #カレンダー情報を取得する
  def get_calendar(m_dates)
    calendar_arr = []
    
    #カレンダーが前の月を跨ぐ時
    prev_month_arr = get_lastmanth_info(m_dates)
    
    #当月の情報を取得
    curr_month_arr = get_currentmonth_info(m_dates)
    
    #来月の情報を取得
    next_month_arr = get_nextmonth_info(m_dates)
    
    #表示するカレンダーの情報を１つn配列にまとめる
    calendar_arr.push(prev_month_arr) if prev_month_arr != nil
    calendar_arr.push(curr_month_arr)
    calendar_arr.push(next_month_arr) if next_month_arr != nil
    calendar_arr.flatten!
    
    return calendar_arr
    
  end
  
  ##カレンダーで表示する先月部分の情報取得
  def get_lastmanth_info(m_dates)
    firstday_of_month = m_dates.beginning_of_month
    
    #月の最初の曜日が日曜日ならnilを返す
    return nil if firstday_of_month.wday == 0
    
    daysinfo_arr = []
    for i in 0..firstday_of_month.wday-1
      index = i - firstday_of_month.wday
      hash_1dayinfo = {"day": firstday_of_month.ago(index.days).day, "month": "prev"}
      daysinfo_arr.push(hash_1dayinfo) 
    end
    
    return daysinfo_arr
  end
  
  #カレンダーで表示する当月分の情報取得
  def get_currentmonth_hash(m_dates)
    
    daysinfo_arr = []
    for i in 1..m_dates.last_of_month.day
      hash_1dayinfo = {"day": i, "month": "curr"}
      daysinfo_arr.push(hash_1dayinfo)
    end
    
    return daysinfo_arr
  end
  
  #カレンダーで表示する来月分の情報取得
  def get_nextmonth_info(m_dates)
    last_of_month = m_dates.end_of_month
    return nil if last_of_month.wday == 6 
    
    daysinfo_arr = []
    for i in 1..(6 - last_of_month.wday)
      hash_1dayinfo = {"day": i, "month": "next"}
      daysinfo_arr.push(hash_1dayinfo)
    end
    
    return daysinfo_arr
  end
end

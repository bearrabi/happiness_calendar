class CalendarsController < ApplicationController
  before_action :move_to_signin, except: :index
  
  def index
    @dates = Time.zone.now
    @calendars = get_calendar(@dates)
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
    
    #先月、当月、来月の情報からカレンダーに表示する日付情報を取得
    prev_month_arr = get_lastmanth_info(m_dates) if m_dates.beginning_of_month.wday != 0
    curr_month_arr = get_currentmonth_info(m_dates)
    next_month_arr = get_nextmonth_info(m_dates) if m_dates.end_of_month.wday != 6
    
    #表示するカレンダーの情報を１つの1一次元配列にまとめる
    calendar_arr.push(prev_month_arr) if prev_month_arr != nil
    calendar_arr.push(curr_month_arr)
    calendar_arr.push(next_month_arr) if next_month_arr != nil
    calendar_arr.flatten!
    
    ##一次元配列から二次元配列に変換する
    calendar_2darr = convert_1darr_to_2darr(7, calendar_arr)
    
    return calendar_2darr
    
  end
  
  ##カレンダーで表示する先月部分の情報取得
  def get_lastmanth_info(m_dates)
    firstday_of_month = m_dates.beginning_of_month
    
    daysinfo_arr = []
    for i in 0..firstday_of_month.wday-1
      index = (-1) * (i - firstday_of_month.wday)
      target_day = firstday_of_month.ago(index.days)
      create_array_to_calendar(daysinfo_arr, target_day, "prev")
    end
    
    return daysinfo_arr
  end
  
  #カレンダーで表示する当月分の情報取得
  def get_currentmonth_info(m_dates)
    firstday_of_month = m_dates.beginning_of_month
    
    daysinfo_arr = []
    for i in 0..m_dates.end_of_month.day-1
      target_day = firstday_of_month.since(i.days)
      create_array_to_calendar(daysinfo_arr, target_day, "curr")
    end
    
    return daysinfo_arr
  end
  
  #カレンダーで表示する来月分の情報取得
  def get_nextmonth_info(m_dates)
    last_of_month = m_dates.end_of_month
    
    daysinfo_arr = []
    for i in 1..(6 - last_of_month.wday)
      target_day = last_of_month.since(i.days)
      create_array_to_calendar(daysinfo_arr, target_day, "next")
    end
    
    return daysinfo_arr
  end
  
  ##カレンダーページに渡すハッシュの配列を作成
  def create_array_to_calendar(m_arr, m_target_day ,m_term)
      dayinfo = Day.find_by(date: Time.local(m_target_day.year,m_target_day.month,m_target_day.day))
      
      if dayinfo != nil
        msgcnt = Message.where(day_id: dayinfo.id).count
      else
        msgcnt = 0
      end
      hash_1dayinfo = {"dateinfo": m_target_day, "term": m_term, "message_count": msgcnt}
      m_arr.push(hash_1dayinfo)
  end
  
  ##一次元配列を二次元配列に変換する
  def convert_1darr_to_2darr(m_div_count, m_source_arr)
    
    rtn_2darr = []
    d1arr = []
    
    ##変換
    m_source_arr.each_with_index do |src, i|
      d1arr[i % m_div_count] = src
      
      ##区切る場所で一次元配列を二次元配列に格納
      if (i % m_div_count == m_div_count - 1)
        rtn_2darr.push(d1arr)
        d1arr = []
      end
      
    end
    
    return rtn_2darr
  end
  
end

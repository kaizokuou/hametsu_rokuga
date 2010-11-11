# -*- coding: utf-8 -*-
class HomeController < ApplicationController
  before_filter :authorize, :except => [:sessions, :login, :feed, :force_all, :sub_feed]
  after_filter :response_save_test

  def index
    i = 0
    begin
      @es = Entity.paginate("torrent_list", :page_size => 1000)[0] 
    rescue SimpleResource::Exceptions::NotFound => e
      logger.debug e
      key = e.to_s.split("/").last
      logger.debug key
      Sql.do_sql "delete from indices where entity_id = 'torrent/#{key}'"
      if i < 10
        i+=1
        retry 
      end
    end
  end

  def search
    @es = []
    Entity.paginate("torrent_list", :page_size => 1000)[0].each do |e|
      @es << e if e.title =~ /#{params[:id]}/
    end
    @es.reverse!
  end

  def sub_feed
    begin
      @es = Entity.paginate("torrent_list", :page_size => 500)[0] 
    rescue SimpleResource::Exceptions::NotFound => e
      p e
    end
    respond_to do |format|
      format.atom
    end
  end


  def list
    @subs = Entity.paginate("subscription_list", :page_size => 500)[0]
    @records = Entity.paginate("record_list", :page_size => 200)[0]
    @comps = Entity.paginate("complete_list", :page_size => 20)[0]
  end

  def stop_record_all
    Entity.paginate("record_list", :page_size => 200)[0].each do |e|
      e.remove_from_index "record_list"
    end
    redirect_to :action => :list
  end

  def destroy_record
    Entity.find(params[:id]).remove_from_index "record_list"
    redirect_to :action => :list
  end

  def force_complete_all
    Entity.paginate("record_list", :page_size => 200)[0].each do |e|
      e.remove_from_index "record_list"
      e.add_to_index "complete_list", Time.now.to_i
      e.add_to_index "hide_list", Time.now.to_i
    end
    redirect_to :action => :list
  end

  def feed
    @comps = Entity.paginate("complete_list", :page_size => 500)[0]
    respond_to do |format|
      format.atom
    end
  end

  def record
    e = Entity.find params[:key]
    e.add_to_index "record_list", Time.now.to_i
    flash[:notice] = "#{e.title} を録画予約しました"
    redirect_to :action => :list
  end

  def subscription
    e = Entity.create "id" => "sub/#{CGI.escape params[:regular]}", "regular" => params[:regular]
    e.add_to_index "subscription_list", Time.now.to_i
    flash[:notice] = "#{params[:regular]} を定期購読しました"
    redirect_to :action => :list
  end

  def force
    regs =  CGI.unescape(params[:key]).split("/").last.split("+")
    p regs
    Entity.paginate("torrent_list", :page_size => 50000)[0].each do |e|
      begin
        if e.index_names.index("complete_list") == nil and e.index_names.index("record_list") == nil
          regs.each do |r|
            if (e.title =~ /#{r}/) == nil or (e.title =~ /1440/) or (e.title =~ /1920/)
              raise
            end
          end
          e.add_to_index "record_list", Time.now.to_i
        end
      rescue
      end
    end
    flash[:notice] = "強制録画予約を発行しました"
    redirect_to :action => :list
  end

  def force_all
    es = Entity.paginate("torrent_list", :page_size => 50000)[0]
    @subs = Entity.paginate("subscription_list", :page_size => 500)[0].each do |sub|
      regs =  sub.regular.split(" ")
      es.each do |e|
        begin
          if e.index_names.index("complete_list") == nil and e.index_names.index("record_list") == nil
            regs.each do |r|
              if (e.title =~ /#{r}/) == nil or (e.title =~ /1440/) or (e.title =~ /1920/)
                raise
              end
            end
            e.add_to_index "record_list", Time.now.to_i
          end
        rescue =>e 
        end
      end
    end
    render :text => "RECORDER"
  rescue => e
    key = "torrent/#{e.to_s.split("/").last}"
    Sql.do_sql("delete from indices where entity_id = '#{key}'")
    raise
  end

  def destroy_subs
    Entity.find(params[:key]).destroy
    flash[:notice] = "購読解除しました"
    redirect_to :action => :list
  end

  def retry
    e = Entity.find CGI.unescape params[:key]
    e.remove_from_index "complete_list"
    e.add_to_index "record_list", Time.now.to_i
    flash[:notice] = "#{e.title} を録画予約しました"
    redirect_to :action => :list
  end

  def sessions
  end

  def login
    user = Entity.find "user/#{params[:name]}"
    raise unless user.password == Digest::SHA1.hexdigest(params[:password])
    session[:login_id] = user.id
    redirect_to :action => :index
  end
end

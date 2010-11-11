class FeedController < ApplicationController
  before_filter :authorize, :except => [:new,:dir,:list,:request_title]
  def new
    @videos = []
    dir = Entity.find("setting").new_feed
    prefix = Entity.find("setting").new_prefix
    Dir.entries(dir).each do |f|
      next if f == "." or f == ".."
      s = File::stat("#{dir}/#{f}")
      v = Video.new
      v.title = f
      v.url = "#{prefix}/#{f}"
      v.id = v.url
      v.path = "#{dir}/#{f}"
      v.created_at = s.mtime
      @videos << v
    end
    @videos.sort!{|a,b| -1*a.created_at.to_i <=> -1*b.created_at.to_i}
  end

  def dir
    e = Entity.find params[:id]
    dir = e.path
    @name = e.name
    prefix = ""
    prefix += "http://URL" #TODO
    i = 0
    e.path.split("/").each do |z|
      if i > 4
        prefix += "/#{z}"
      end
      i+=1
    end
    @videos = []
    Dir.entries(dir).each do |f|
      next if f == "." or f == ".."
      s = File::stat("#{dir}/#{f}")
      v = Video.new
      v.title = f
      v.url = "#{prefix}/#{f}"
      v.id = v.url
      v.path = "#{dir}/#{f}"
      v.created_at = s.mtime
      @videos << v
    end
    @videos.sort!{|a,b| a.title <=> b.title}
  end

  def list
    @list = Entity.paginate("feed_dir_list", :page_size => 10000).first
  end

  def edit
    @list = Entity.paginate("feed_dir_list", :page_size => 10000).first
    @titles = Entity.paginate("request", :page_size => 10000).first
  end

  def register
    Entity.find_or_create_with_lock(Digest::SHA1.hexdigest("feed_dir/#{CGI.escape params[:path]}"),{}) do |e|
      e.path = params[:path]
      if params[:name] == nil or params[:name] == ""
        e.name = params[:path].split("/").last
      else
        e.name = params[:name]
      end
      e.save
      e.add_to_index "feed_dir_list", Time.now.to_i
    end
    redirect_to :action => :edit
  end

  def destroy
    Entity.find(params[:id]).destroy
    redirect_to :action => :edit
  end

  def request_title
    e = Entity.new
    e.name = params[:name]
    e.save
    e.add_to_index "request", Time.now.to_i
    redirect_to :action => :list
  end

  def destroy_request
    e = Entity.find params[:id]
    e.destroy
    redirect_to :action => :edit
  end
end

# -*- coding: utf-8 -*-
class SettingsController < ApplicationController
  before_filter :authorize
  
  def index
    @setting = Entity.find "setting" rescue @setting = Entity.new
  end

  def update
    Entity.find_or_create_with_lock("setting",{}) do |e|
      e.nyaa_urls = params[:nyaa_urls].split(" ").to_json
      e.after_command = params[:after_command].split("\n").to_json
      e.start_port = params[:start_port].to_i
      e.concurrency_count = params[:concurrency_count].to_i
      e.download_directory = params[:download_directory]
      e.new_feed = params[:new_feed]
      e.new_prefix = params[:new_prefix]
      e.save
    end
    redirect_to :action => :index
  end
end

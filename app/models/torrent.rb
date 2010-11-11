class Torrent
  require "thread"
  def self.runner
    start_port = Entity.find("setting").start_port.to_i
    count = Entity.find("setting").concurrency_count.to_i
    dir = Entity.find("setting").download_directory
    while true
      
      begin
      system "rm -rf #{dir}/*torrent"
      @threads = []
      @a = 0
      Entity.paginate("record_list", :page_size => count)[0].each do |e|
        if e.index_names.index("hide_list") == nil
          @threads << Thread.start do
            @a += 1
            puts "Start Download #{e.title}"
            system "transmissioncli '#{e.href}' -p #{start_port+@a} -w '#{dir}'"
            e.remove_from_index "record_list"
            e.add_to_index "complete_list", Time.now.to_i
            puts "Complete #{e.title}"
          end
        else
        end
        sleep 2
      end
      size = @threads.size
      @threads.each{|t| t.join rescue nil}
      Misc.exec_after_command
      sleep 4
      rescue
        retry
      end
    end
  end
end

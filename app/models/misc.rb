class Misc
  def self.json_to_line json
    str = ""
    JSON.parse(json).each do |e|
      str += e+" "
    end
    return str
  rescue 
    nil
  end

  def self.json_to_area json
    str = ""
    JSON.parse(json).each do |e|
      str += e+"\n"
    end
    return str
  rescue 
    nil
  end

  def self.exec_after_command
    JSON.parse(Entity.find("setting").after_command).each do |c|
      puts c
      system c
    end
    true
  end
end

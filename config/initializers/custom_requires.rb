Dir.glob(::Rails.root.to_s + '/lib/*.rb'){|file|
  require file
}
require "#{::Rails.root.to_s}/lib/simple_resource/base.rb"
require "#{::Rails.root.to_s}/lib/simple_resource/tt_entity_backend.rb"
require "#{::Rails.root.to_s}/lib/simple_resource/pure_memcached.rb"
require "#{::Rails.root.to_s}/lib/simple_resource/mysql_index_backend.rb"
require "#{::Rails.root.to_s}/lib/simple_resource/mysql_entity_backend.rb"
require "#{::Rails.root.to_s}/lib/simple_resource/mysql_index.rb"
require "#{::Rails.root.to_s}/lib/simple_resource/index_name.rb"
require "#{::Rails.root.to_s}/lib/simple_resource/pager.rb"

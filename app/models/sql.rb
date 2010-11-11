class Sql < ActiveRecord::Base
  def self.do_sql (sql)
    logger.debug "SQL #{sql}"
    return connection.execute(sql)
  rescue => e
    logger.debug e
  end
end

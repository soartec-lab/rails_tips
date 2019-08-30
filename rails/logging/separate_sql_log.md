applicationログはinfoで出したいけど、別途SQLログも出したい時


```config/application.rb:ruby
  ActiveRecord::Base.logger = Logger.new('log/sql.log')
  ActiveRecord::Base.logger.formatter = proc do |severity, timestamp, progname, msg|
    {
      timestamp: timestamp.iso8601,
      LOG_LEVEL: severity,
      message: msg
    }.to_json << "\n"
  end
```

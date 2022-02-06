# カスタムログ

## カスタムロガーを追加したい場合

`config/application.rb`もしくは、`config/enviroments/`配下の各環境設定ファイル内で以下を指定

```ruby
config.sample_logger = Logger.new(Rails.root.join('log/sample.log'))
```

# ログフォーマット

## 日時のフォーマットを変更
Logger#datetime_format= を用いてログに記録する時の日時のフォーマッ トを変更することもできます。

```ruby
logger.datetime_format = '%Y-%m-%d %H:%M:%S'
# e.g. "2004-01-03 00:54:26"
```

コンストラクタでも同様にできます。

```ruby
require 'logger'
Logger.new(logdev, datetime_format: '%Y-%m-%d %H:%M:%S')
```

## フォーマットを変更

Logger#formatter= を用いてフォーマットを変更することもできます。
4つの引数 (severity, time, program name, message) を受け取る call メソッドを 持つオブジェクトを指定します。call メソッドの返り値は文字列にしてください。

### Procオブジェクトを指定する場合

```ruby
logger.formatter = proc do |severity, datetime, progname, msg|
  "#{datetime}: #{msg}\n"
end
# => "2005-09-22 08:51:08 +0900: hello world"
```

### 独自で作成したclassのオブジェクトを指定する場合

```ruby
logger.formatter = SampleLoggerFormatter.new

class SampleLoggerFormatter
  def call(severity, timestamp, progname, msg)
    "#{datetime}: #{msg}\n"
  end
end
```

#### e.g. rails標準のログ要素をJsonに変換して出力する場合

```ruby
class JsonFormatter
  def call(severity, timestamp, progname, msg)
    {
      timestamp: timestamp.iso8601,
      LOG_LEVEL: severity,
      message: msg
    }.to_json << "\n"
  end
end

logger.formatter = JsonFormatter.new
```

#### e.g. rails標準のログ要素に加えてカスタムフィールドを出力したい場合

```ruby
class CustomFormatter
  def call(severity, timestamp, _, custom_fields)
    {
      timestamp: timestamp.iso8601,
      LOG_LEVEL: severity,
      user_type: custom_fields[:user_type],
      user_rank: custom_fields[:user_rank],
    }.to_json << "\n"
  end
end

logger.formatter = CustomFormatter.new

Rails.application.config.logger.inf(user_type: 0, user_rank: 1)
```

### コンストラクタで指定する場合。

```ruby
require 'logger'

Logger.new(logdev, formatter: proc {|severity, datetime, progname, msg|
  "#{datetime}: #{msg}\n"
})
```

# Rubyリファレンスマニュアル
https://docs.ruby-lang.org/ja/2.6.0/library/logger.html

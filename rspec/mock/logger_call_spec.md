# ログ出力を呼び出す事の確認
mockでテストする

## 例えば
このようなカスタムログを設定していて、
```
config.custom_logger = Logger.new(Rails.root.join('log/custom.log'))
config.custom_logger.formatter = CustomLogFormatter.new
```

そのログを出力するメソッドがあった場合

```
class Sample
  def self.logging
    Rails.application.config.custom_logger.info("logging")
  end
end
```

rspecでは、呼び出しができていることを確認する

```
it do
  expect(Rails.application.config.custom_logger).to receive(:info).with("logging")

  Sample.logging
end
```

`.with`についての詳細は、https://relishapp.com/rspec/rspec-mocks/v/3-2/docs/setting-constraints/matching-arguments


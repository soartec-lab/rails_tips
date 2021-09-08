# Boolean型のattributeにpresence: trueを検証したい場合はinclusionを使う

Boolean型のattributeが入力必須の場合にpresence: trueをつけてしまうとfalseが指定されている場合に全てinvalidと判定されてしまう。
validationの実装でfalse.blank?が使われておりinvalidと判定されるため。

## 対応方法

`inclusion: { in: [true, false] }`を使用する。

```
validates :boolean_field_name, inclusion: { in: [true, false] }
```

## rails guide
> false.blank?は常にtrueなので、真偽値に対してこのメソッドを使うと正しい結果が得られません。真偽値の存在をチェックしたい場合は、validates :field_name, inclusion: { in: [true, false] }を使う必要があります。
> 
> validates :boolean_field_name, inclusion: { in: [true, false] }
> validates :boolean_field_name, exclusion: { in: [nil] }

See: https://railsguides.jp/active_record_validations.html#presence

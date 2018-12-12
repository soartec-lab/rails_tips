# ヘルパー`validates_with`を使用して、バリデーション処理をを専用の別クラスに委譲する。

## 使い方

### 元のコード

シンプルな構成
PersonClassにvalidatesを定義

```app/models/parson.rb
class Person < ApplicationRecord
  validates :validate

  def validate(record)
    if record.first_name == "Evil"
      record.errors[:base] << "これは悪人だ"
    end
  end
end
```

### validates用のクラスを作成

```app/validates/parson_validator.rb
class GoodnessValidator < ActiveModel::Validator

  def evil_validate(record)
    if record.first_name == "Evil"
      record.errors[:base] << "これは悪人だ"
    end
  end
end
```

### validates用のクラスをvalidates_withで読み込む

```app/models/parson.rb
- class Person < ApplicationRecord
-   validates :validate

-   def validate(record)
-     if record.first_name == "Evil"
-       record.errors[:base] << "これは悪人だ"
-     end
-   end
- end

+ class Person < ApplicationRecord
+   validates_with GoodnessValidator
+ end
```

# 参考

Rails Guide
https://railsguides.jp/active_record_validations.html#validates-with
validates用のクラスを
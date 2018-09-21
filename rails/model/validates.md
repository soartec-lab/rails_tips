# validatesで独自のバリデーションを使用する

標準validateに無いバリデーションを行いたい場合

```models/user.rb
class User < ActiveRecord::Base
  validate :name_valid?

  private

  def name_valid?
    if バリデーション条件
      errors.add(:name)
    end
  end
end
```

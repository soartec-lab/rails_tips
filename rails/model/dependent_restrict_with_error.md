# has_manyのオプション dependent: :restrict_with_error

# 前提

以下の様にUserが複数のItemを持っていた場合、
親モデルのUserを削除した場合、子モデルItemのuser_idの参照先が無くなってしまいデータが壊れてしまいます。

```
Class User < ApplicationRecord
  has_meny :items
end

Class Item < ApplicationRecord
  belongs_to :user

```

railsではassociationのオプションに`dependency`を指定する事で、
削除前にコールバックを実行しデータを担保する仕組みが用意されています。

# 使い方

`dependent: :restrict_with_error`を指定し、
関連付けられたオブジェクトが1つでもある場合エラーを発生させ、
親モデルを削除しない様にします。

```
Class User < ApplicationRecord
  has_meny :items, dependent: :restrict_with_error
end

Class Item < ApplicationRecord
  belongs_to :user

```

# restrict_with_errorのエラーメッセージのi18n対応

エラーメッセージをi18n対応

```config/local/custom.ja
ja:
  activerecord:
    errors:
      messages:
        restrict_dependent_destroy:
          many: "%{record}が存在しているため削除できません。"
```

`%{record}`の部分をi18n化する為に`attributes`を定義
定義の仕方は、

* `attributes`の直下に、子モデルの単数形
* `子モデルの単数形`の直下に、子モデルの複数形

```
attributes:
  子モデルの単数形:
    子モデルの複数形: 商品
```

```config/local/custom.ja
ja:
  activerecord:
    errors:
      messages:
        restrict_dependent_destroy:
          many: "%{record}が存在しているため削除できません。"
    attributes:
      item:
        items: 商品
```


# 参考
https://railsguides.jp/association_basics.html
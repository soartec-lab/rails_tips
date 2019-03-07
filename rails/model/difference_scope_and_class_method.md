# クラスメソッドとscopeの違い

Rails5.2までのガイドには以下の記述がありましたが実際は全く違います。
Rails6.0から記述が削除されています。

```
This is exactly the same as defining a class method, and which you use is a matter of personal preference:

訳: スコープでのメソッドの設定は、クラスメソッドの定義と完全に同じ (というよりクラスメソッドの定義そのもの) です。どちらの形式を使用するかは好みの問題です。
```

## scope

### 基本的にActiveRecord::Relationを返す。
```ruby
class User < ApplicationRecord
  scope :royal, -> { find_by(royal: true) }
end
```

scopeの結果がnilの場合`.all`の結果が返る

```ruby
$ User.find_by(royal: true)
=> nil

$ User.count
=> 100

$ User.royal == User.all
=> true
```

#### nilを返さないのでscopeをメソッドチェインして使える

### 正し、以下の場合はnilを返す。

```ruby
scope :empty, -> { [] }
```

## クラスメソッド

#### nilを返すのでメソッドチェインして使うと`NoMethodError`が発生する可能性がある

# 参考
## nilを返すケース
https://github.com/rails/rails/issues/34532

## warningを入れるか、raiseするかの検討PR
https://github.com/rails/rails/pull/32846

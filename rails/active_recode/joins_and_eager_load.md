# `joins`メソッドと`eager_load`メソッドを同時に使うとINNER JOINした結果をcacheできる

以下の様にした場合にINNER JOINしたカラムをcacheしてくれる

```ruby
User.joins(:item).eager_load(:item)
```

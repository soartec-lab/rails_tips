# ログ設計

## ログにタグ付けをし、ログ種別を識別する
`logger.tagged`を使用する事で、ログにタグを付ける事が可能です。
例えば、サブドメインやリクエストIDなどを指定してデバックに役立てます。

```ruby
$ logger.tagged("BCX", "Jason") { logger.info "Stuff" }
#=> [BCX] [Jason] Stuff
```
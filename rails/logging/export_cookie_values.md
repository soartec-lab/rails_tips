# Railsのログにcookieの値を出力する

`config.log_tags`を使ってログ情報追加する。

`rails new`するとデフォルトで`config/enviroments`配下の環境別ファイルに記述されている設定値。

RailsGuideより
> config.log_tags: 次のリストを引数に取ります（requestオブジェクトが応答するメソッド、requestオブジェクトを受け取るProc、またはto_sに応答できるオブジェクト）。これは、ログの行にデバッグ情報をタグ付けする場合に便利です。たとえばサブドメインやリクエストidを指定することができ、これらはマルチユーザーのproductionアプリケーションをデバッグするのに便利です。

requestオブジェクトを受け取るProcを指定できるので、以下の様に`lambda`を指定する

```diff:config/enviroments/production.rb
Rails.configuration.log_tags = [
  :request_id,
+  lambda {|req| req.cookies["_hoge_session"]}
]
```


# CSRF対策について

`form_tag`を使用するとUIの為の`inputタグ`と`type = "hidden"`の`inputタグ`が作成される

```html
<form accept-charset="UTF-8" action="/home/index" method="post">
  <div style="margin:0;padding:0">
    <input name="utf8" type="hidden" value="&#x2713;" />
    <input name="authenticity_token" type="hidden" value="f755bb0ed134b76c432144748a6d4b7a7ddf2b71" />
  </div>
  Form contents
</form>
```

Railsは以下の2つに同様のCSRFトークンを埋めこみます。

* `<input name="authenticity_token" type="hidden" value="f755bb0ed134b76c432144748a6d4b7a7ddf2b71" />`の`value`
* セッションcookie

ユーザーがPOSTリクエストを送信するときに、HTMLに埋められていたCSRFトークンも一緒に送信されます。
Railsはページのトークンとセッション内のトークンを比較し、両者が一致することを確認します。


# 参考
## 記事
https://techracho.bpsinc.jp/hachi8833/2017_10_23/46891

## RailsGuide
https://railsguides.jp/security.html#%E3%82%AF%E3%83%AD%E3%82%B9%E3%82%B5%E3%82%A4%E3%83%88%E3%83%AA%E3%82%AF%E3%82%A8%E3%82%B9%E3%83%88%E3%83%95%E3%82%A9%E3%83%BC%E3%82%B8%E3%82%A7%E3%83%AA-csrf

## Rails/Rails
### 検証
https://github.com/rails/rails/blob/master/actionpack/lib/action_controller/metal/request_forgery_protection.rb#L135

### CSRFトークン生成
https://github.com/rails/rails/blob/master/actionview/lib/action_view/helpers/csrf_helper.rb#L22
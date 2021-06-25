# CSRF対策のトークン突合処理について

## 前提

[CSRF対策について](csrf_verification.md)

## トークンの生成

`Rails new` した後の`app/views/layouts/application.html.erb`に`<%= csrf_meta_tags %>`のタグが記述されています。
この`csrf_meta_tags`メソッドは以下の定義がされています。

```ruby
def csrf_meta_tags
  if defined?(protect_against_forgery?) && protect_against_forgery?
    [
      tag("meta", name: "csrf-param", content: request_forgery_protection_token),
      tag("meta", name: "csrf-token", content: form_authenticity_token)
    ].join("\n").html_safe
  end
end
```

レンダリングされるとする時に以下を行います。

* SettionStoreにトークンを格納

`SessionStore`を設定している場合はそのストアを見に行きます。

* HTMLに暗号化したトークンを出力

以下のようなHTMLが生成されます。

```html
<meta name="csrf-param" content="authenticity_token" />
<meta name="csrf-token" content="vtaJFQ38doX0b7wQpp0G3H7aUk9HZQni3jHET4yS8nSJRt85Tr6oH7nroQc01dM+C/dlDwt5xPff5LwyZcggeg==" />
```

# 検証

ユーザーがPOSTリクエストを送信するときに、HTMLに埋められていたCSRFトークンも一緒に送信されます。
RailsのCSRF対策では、以下の2つのトークンが同一か検証します。

* `<meta name="csrf-token" content="vtaJFQ38doX0b7wQpp0G3H7aUk9HZQni3jHET4yS8nSJRt85Tr6oH7nroQc01dM+C/dlDwt5xPff5LwyZcggeg==" />`に埋め込まれたトークン`vtaJFQ38doX0b7wQpp0G3H7aUk9HZQni3jHET4yS8nSJRt85Tr6oH7nroQc01dM+C/dlDwt5xPff5LwyZcggeg==`または、リクエストヘッダー`X-XSRF-TOKEN`として送信されるトークン

* SettionStoreで保持しているトークン

例えばセッションストアにredisが指定されている場合以下の処理が実行されます。

1. クライアントからリクエスト受付
2. リクエストのCookieからセッションIDを読み取る
3. 読み取ったセッションIDを元にredisからtokenを取り出す。
4. 取り出したtokenとクライアントから送られてきたtokenが同一か検証。

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

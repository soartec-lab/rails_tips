# CSRF対策のorigin検証について

## 前提

[CSRF対策について](csrf_verification.md)

## origin検証について

CSRF検証メソッドの`valid_request_origin?`について書いていきます。

```ruby
def verified_request? # :doc:
  !protect_against_forgery? || request.get? || request.head? ||
    (valid_request_origin? && any_authenticity_token_valid?)
end
```
See: https://github.com/rails/rails/blob/6-0-stable/actionpack/lib/action_controller/metal/request_forgery_protection.rb#L285-L288

```ruby
def valid_request_origin? # :doc:
  if forgery_protection_origin_check
    # We accept blank origin headers because some user agents don't send it.
    raise InvalidAuthenticityToken, NULL_ORIGIN_MESSAGE if request.origin == "null"
    request.origin.nil? || request.origin == request.base_url
  else
    true
  end
end
```
See: https://github.com/rails/rails/blob/6-0-stable/actionpack/lib/action_controller/metal/request_forgery_protection.rb#L451-L459

`forgery_protection_origin_check`ではアプリケーションの設定値`forgery_protection_origin_check`の値を確認する。デフォルトは`true`なので、明示的に`false`に設定してある場合のみCSRF検証処理をスキップする。

`request.origin == "null"`の場合は、`InvalidAuthenticityToken`をraiseする。

`request.origin.nil?`について`request.origin`はリクエストヘッダーの`HTTP_ORIGIN`の値を取得する。

See: https://github.com/rails/rails/blob/6-0-stable/actionpack/lib/action_dispatch/http/request.rb#L33-L53

`request.origin == request.base_url`では前述のリクエストヘッダーの`HTTP_ORIGIN`と`request.base_url`を比較する。`base_url`はrackのメソッドです。

```ruby
def base_url
  "#{scheme}://#{host_with_port}"
end
```
See: https://github.com/rack/rack/blob/649c72bab9e7b50d657b5b432d0c205c95c2be07/lib/rack/request.rb#L502-L504

```ruby
def scheme
  if get_header(HTTPS) == 'on'
    'https'
  elsif get_header(HTTP_X_FORWARDED_SSL) == 'on'
    'https'
  elsif forwarded_scheme
    forwarded_scheme
  else
    get_header(RACK_URL_SCHEME)
  end
end
```
https://github.com/rack/rack/blob/649c72bab9e7b50d657b5b432d0c205c95c2be07/lib/rack/request.rb#L210-L220

```ruby
def forwarded_scheme
  allowed_scheme(get_header(HTTP_X_FORWARDED_SCHEME)) ||
  allowed_scheme(extract_proto_header(get_header(HTTP_X_FORWARDED_PROTO)))
end

def allowed_scheme(header)
  header if ALLOWED_SCHEMES.include?(header)
end
```
See: https://github.com/rack/rack/blob/649c72bab9e7b50d657b5b432d0c205c95c2be07/lib/rack/request.rb#L626-L633

リクエストヘッダーの`HTTPS`, `HTTP_X_FORWARDED_SSL`, `HTTP_X_FORWARDED_SCHEME`, `HTTP_X_FORWARDED_PROTO`を確認してschemeを作成してます。

## ソースコードbranch

rails: 6-0-stable
https://github.com/rails/rails/blob/6-0-stable/actionpack/lib/action_controller/metal/request_forgery_protection.rb
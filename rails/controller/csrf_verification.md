# CSRF対策について

コントローラーで`protect_from_forgery`が呼び出されるとrailsの以下のコードが実行される。

```ruby
def protect_from_forgery(options = {})
  options = options.reverse_merge(prepend: false)

  self.forgery_protection_strategy = protection_method_class(options[:with] || :null_session)
  self.request_forgery_protection_token ||= :authenticity_token
  before_action :verify_authenticity_token, options
  append_after_action :verify_same_origin_request
end
```
See: https://github.com/rails/rails/blob/6-0-stable/actionpack/lib/action_controller/metal/request_forgery_protection.rb#L127-L134

`before_action :verify_authenticity_token, options`が実行され、コントローラー内のコールバックに`verify_authenticity_token`が追加される。

`verify_authenticity_token`の処理は以下のように`verified_request?`が`false`の場合は`handle_unverified_request`を実行する。

```ruby
def verify_authenticity_token # :doc:
  mark_for_same_origin_verification!

  if !verified_request?
    if logger && log_warning_on_csrf_failure
      if valid_request_origin?
        logger.warn "Can't verify CSRF token authenticity."
      else
        logger.warn "HTTP Origin header (#{request.origin}) didn't match request.base_url (#{request.base_url})"
      end
    end
    handle_unverified_request
  end
end
```
See: https://github.com/rails/rails/blob/6-0-stable/actionpack/lib/action_controller/metal/request_forgery_protection.rb#L223-L236

`handle_unverified_request`は`ActionController::InvalidAuthenticityToken`をraiseする。
See: https://github.com/rails/rails/blob/6-0-stable/actionpack/lib/action_controller/metal/request_forgery_protection.rb#L206-L208

CSRF対策の検証自体は`verified_request?`で行っている。
この中に書いてあるいずれかの処理が`false`やった場合に`false`を返す。

```ruby
def verified_request? # :doc:
  !protect_against_forgery? || request.get? || request.head? ||
    (valid_request_origin? && any_authenticity_token_valid?)
end
```
See: https://github.com/rails/rails/blob/6-0-stable/actionpack/lib/action_controller/metal/request_forgery_protection.rb#L285-L288

`!protect_against_forgery?`ではアプリケーションの設定値`allow_forgery_protection`の値を確認する。デフォルトは`true`なので、明示的に`false`に設定してある場合のみCSRF検証処理をスキップする。

`request.get?`, `request.head?`ではリクエスト(`ActionDispatch::Request`クラスのオブジェクト)のhttpメソッドを確認しGET, HEADの場合はCSRF検証処理をスキップする。

`(valid_request_origin? && any_authenticity_token_valid?)`ではoriginの検証とトークンの検証を行っている。

`valid_request_origin?`については[origin検証](./csrf_origin_verification.md)で、
`any_authenticity_token_valid?`については[token検証](./csrf_token_verification.md)
に記述しています。

## ソースコードbranch

rails: 6-0-stable
https://github.com/rails/rails/blob/6-0-stable/actionpack/lib/action_controller/metal/request_forgery_protection.rb
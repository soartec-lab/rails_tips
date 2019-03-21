# I18n評価の遅延化

Railsには、 ビュー 内部でロケールを参照するときに便利な方法が実装されています。以下のような辞書があるとします。

```yaml
es:
  books:
    index:
      title: "Título"
```

以下のようにして、`app/views/books/index.html.erb`ビューテンプレート 内部 で`books.index.title`値にアクセスできます。ドットが使われていることにご注目ください。
ドットを使用する事で評価の遅延を行う事が可能です。

```ruby
<%= t '.title' %>
```

遅延評価をする事で以下の`.title`は`@sample`が`false`の場合は値の評価を行わない為パフォーマンスの向上が図れます。

```ruby
<%= if @sample.true?%>
  <%= t '.title' %>
<%= end %>
```
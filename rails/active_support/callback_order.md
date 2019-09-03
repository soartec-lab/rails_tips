# rails6の`ActiveSupport::Callbacks`の各コールバックの実行順序

## 結論

`before_*`, `around_*`はキューに積まれた新しい順番に、
`after_*`は積まれた順番の古い順に処理される

> # Calls the before and around callbacks in the order they were set, yields
> # the block (if given one), and then runs the after callbacks in reverse
> # order.

See: https://github.com/rails/rails/blob/master/activesupport/lib/active_support/callbacks.rb#L76-L78

## 実装
### キューを処理する処理
まずコールバックの実行自体は`ActiveSupport::Callbacks#run_callbacks`(https://github.com/rails/rails/blob/master/activesupport/lib/active_support/callbacks.rb#L96-L141)で処理されます。

その中の以下の処理で処理順を並び替えています。

```ruby
callbacks.compile

# See: https://github.com/rails/rails/blob/master/activesupport/lib/active_support/callbacks.rb#L103
```

```ruby
def compile
  @callbacks || @mutex.synchronize do
    final_sequence = CallbackSequence.new
    @callbacks ||= @chain.reverse.inject(final_sequence) do |callback_sequence, callback|
      callback.apply callback_sequence
    end
  end
end

# See: https://github.com/rails/rails/blob/d94263f3e76527f196cab2026cfa119ff26b6d9e/activesupport/lib/active_support/callbacks.rb#L562-L569
```

ポイントは`reverse`している所です。
処理するときは、積まれたキューを`reverse`して頭から処理していきます。

### キューを積む処理

キューを積む時は`set_callback`はが呼ばれます。
その中で、`prepend`と`append`どちらかが呼び出されます。

```
        def set_callback(name, *filter_list, &block)
          type, filters, options = normalize_callback_params(filter_list, block)

          self_chain = get_callbacks name
          mapped = filters.map do |filter|
            Callback.build(self_chain, filter, type, options)
          end

          __update_callbacks(name) do |target, chain|
            options[:prepend] ? chain.prepend(*mapped) : chain.append(*mapped)
            target.set_callbacks name, chain
          end
        end


# See: https://github.com/rails/rails/blob/d94263f3e76527f196cab2026cfa119ff26b6d9e/activesupport/lib/active_support/callbacks.rb#L673-L685
```

```
        def append(*callbacks)
          callbacks.each { |c| append_one(c) }
        end

        def prepend(*callbacks)
          callbacks.each { |c| prepend_one(c) }
        end

# See: https://github.com/rails/rails/blob/d94263f3e76527f196cab2026cfa119ff26b6d9e/activesupport/lib/active_support/callbacks.rb#L571-L577
```

この`skip_callback(name, *filter_list, &block)`を呼び出す時の第二引数`*filter_list`の値によって配列の順序を変更しています。

## 詳しく結論

### キューを積む時
`before_*`, `around_*`は`prepend` -> 先頭に追加
# 先頭から古い順

`after_*`は`apend` -> 末尾に追加
# 先頭から新しい順

###キューを処理する時

`reverse`して先頭から処理していくので、
`before_*`, `around_*`はキューに積まれた新しい順番に、
`after_*`は積まれた順番の古い順に処理されます。

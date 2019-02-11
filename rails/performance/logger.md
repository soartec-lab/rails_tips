# 気を付ける点

ログ出力でのパフォーマンス影響はわずかだが、loggerメソッドを多数呼び出しているアプリケーションで
は注意が必要。

例えば、以下のコードには2つのパフォーマンス低下の懸念点があります。

```
logger.debug "Person attributes hash: #{@person.attributes.inspect}"
```

* 比較的動作が重いStringオブジェクトのインスタンス化
* 実行に時間のかかる変数の式展開 (interpolation) 

# 対策

loggerの引数をブロックとして渡しておきます。
渡したブロックの内容 (ここでは文字列の式展開) は、debugログが有効になっている場合にしか評価されません。

```
logger.debug {"Person attributes hash: #{@person.attributes.inspect}"}
```

この方法によるパフォーマンスの改善は、大量のログを出力しているときでないとそれほど実感できないかもしれませんが、それでも採用する価値があります。

# 参考

https://railsguides.jp/debugging_rails_applications.html#%E3%83%AD%E3%82%B0%E3%81%8C%E3%83%91%E3%83%95%E3%82%A9%E3%83%BC%E3%83%9E%E3%83%B3%E3%82%B9%E3%81%AB%E4%B8%8E%E3%81%88%E3%82%8B%E5%BD%B1%E9%9F%BF
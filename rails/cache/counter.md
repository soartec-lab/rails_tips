# RubyOnRailsで数を数えるメソッドのき挙動の違い

## size
キャッシュ(メモリ上に保持されているcollection)が存在している場合、キャッシュされている値を返す。
キャッシュが存在していない場合、SQLのCOUNT句を発行する。

## count
SQLのCOUNT句を発行する。

## length
メモリ上に保持されているcollectionが存在している場合
-> `size`と全く同様

メモリ上に保持されているcollectionが存在しない場合
-> SQLの実行結果に対しRubyの言語レベルで行数を数える。
   SQLのCOUNT句は発行しない。

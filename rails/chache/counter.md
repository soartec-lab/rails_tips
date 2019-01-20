# RubyOnRailsで数を数えるメソッドのき挙動の違い

## size
キャッシュが存在している場合、キャッシュされている値を返す。
キャッシュが存在していない場合、SQLのCOUNT句を発行する。

## count
キャッシュの存在を確認せず、SQLのCOUNT句を発行する。

## length
SQLの実行結果に対しRubyの言語レベルで行数を数える。
SQLのCOUNT句は発行しない。
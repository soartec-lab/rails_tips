# RailsのN+1対策について

# ActiveRecordのメソッドについて

RailsでN+1対策をする時に使用するメソッド3つ`eager_load`, `preload`, `includes`について使用するケースをメモします。

## `eager_load`

* 引数に指定したassociationを`LEFT OUTER JOIN`で取得してキャッシュします。
* `preload`と違い一度のクエリで値を取得します。

```ruby
$ User.eager_load(:posts)
#=> SELECT `users`.`id` AS t0_r0, `users`.`name` AS t0_r1, `users`.`created_at` AS t0_r2, `users`.`updated_at` AS t0_r3, `posts`.`id` AS t1_r0, `posts`.`user_id` AS t1_r1, `posts`.`created_at` AS t1_r2, `posts`.`updated_at` AS t1_r3 FROM `users` LEFT OUTER JOIN `posts` ON `posts`.`user_id` = `users`.`id`
```

* `where`メソッド等をチェインできます。
* 対象テーブルのデータサイズが大きく`join`のコストが大きい場合にパフォーマンスが悪くなる場合があります。

## `preload`

* 引数に指定したassociationを`LEFT OUTER JOIN`で取得してキャッシュします。
* `eager_load`と違い複数のクエリで値を取得します。

```ruby
$ User.preload(:posts)
#=> SELECT `users`.* FROM `users`
#=> SELECT `posts`.* FROM `posts` WHERE `posts`.`user_id` IN (1, 2, 3, ...)
```

* **`where`メソッド等をチェインできません。**
* 対象テーブルのデータサイズが大きく`join`のコストが大きい場合に有効です。

## `includes`
Activerecordが最終的に生成するクエリに合わせて`eager_load`か`preload`の挙動を行う。

**個人的に、includesをassociationをLEFT OUTER JOIN使う事は以下の理由からオススメしません。**
後で自分が見た時や他の人が見た時に`eager_load`か`preload`のどちらを使用したかったのか意図がわからなくなる為です。意図が読み解けたとしても、そこに掛ける時間がもったいないので、コードを書いた時に意図が分かるようにしておいた方が良いと思います。
コードリーディング時よりも、チューニングする時に意図がわからず困る可能性が高いです。

# `eager_load`と`preload`のどちらを使うか

SQLは単純にクエリ発行数を減らせば良い場合とそうでない場合があり、テーブルサイズ、レコード数などの条件によって判断する必要があります。

例えば、データサイズが小さい、レコード数が少ないテーブルを処理する場合はクエリ発行数の少ない`eager_load`が有効な場合が多いと思います。
逆に、データサイズが大きい、レコード数が多いテーブルを`eager_load`で処理しようとした場合に、データがDBのワークメモリに収まりきれずディスク使用が発生し遅くなるという事もありえます。その場合は`preload`の方が有効です。

# 参考
https://qiita.com/k0kubun/items/80c5a5494f53bb88dc58
https://qiita.com/ostk0069/items/23beb870adf785506be2
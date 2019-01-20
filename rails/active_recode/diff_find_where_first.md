# findとwhere(id: XXX).firstの違い

## find

* 返り値はレシーバーのオブジェクト
* DB問い合わせを行う
* 発行SQLに`order by id desc`が付与されない

## where

* where()の返り値はActiveRecord_Relation
* `where().first`、`where().map()`などデータを操作するタイミングでDB問い合わせを行う
* 発行SQLに`order by id desc`が付与される

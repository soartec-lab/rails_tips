# ActiveRecordのhas_manyで追加させるメソッド`collection<<`は注意する。

# 理由

レシーバーの状態によって挙動が変わるメソッドなので、
どんな挙動が意図しているのかコードリーディング時に解り難い。
= 可読性が低い

# 説明

DBから取ってきたPatientに対し`<<`メソッドを使用し場合、insert句が発行されない。

```ruby
[19] pry(main)> Patient.take.physicians << Physician.new
  Patient Load (0.4ms)  SELECT  "patients".* FROM "patients" LIMIT ?  [["LIMIT", 1]]
   (0.1ms)  begin transaction
  SQL (13.7ms)  INSERT INTO "physicians" ("created_at", "updated_at") VALUES (?, ?)  [["created_at", "2019-02-23 17:22:01.562585"], ["updated_at", "2019-02-23 17:22:01.562585"]]
  SQL (0.3ms)  INSERT INTO "patients_physicians" ("physician_id", "patient_id", "created_at", "updated_at") VALUES (?, ?, ?, ?)  [["physician_id", 3], ["patient_id", 1], ["created_at", "2019-02-23 17:22:02.151909"], ["updated_at", "2019-02-23 17:22:02.151909"]]
   (46.3ms)  commit transaction
  Physician Load (0.4ms)  SELECT "physicians".* FROM "physicians" INNER JOIN "patients_physi
  cians" ON "physicians"."id" = "patients_physicians"."physician_id" WHERE "patients_physicians"."patient_id" = ?  [["patient_id", 1]]
=> [#<Physician:0x00007ffff122b250
  id: 3,
  name: nil,
  created_at: Sat, 23 Feb 2019 17:22:01 UTC +00:00,
  updated_at: Sat, 23 Feb 2019 17:22:01 UTC +00:00>]
```

DBに保存していないPatientに対し`<<`メソッドを使用した場合、insert句が発行されない。

```ruby
[24] pry(main)> Patient.new.physicians << Physician.new
=> [#<Physician:0x00007ffff158de98 id: nil, name: nil, created_at: nil, updated_at: nil>]
```

## 対応

使う側が意図を示すコードを明示的に書く。

* DBに登録したい
* DBに保存済みのレシーバー

のcollection対し要素を追加する場合は`collection.create`

* DBではなくめもりに追加したい
* DBに保存前のレシーバー

のcollection対し要素を追加する場合は`collection.build`

をそれぞれ使った方がよいと思います。
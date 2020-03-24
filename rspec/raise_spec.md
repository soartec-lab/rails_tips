# rspecで例外発生後の状態を確認する方法
以下のspecで`SmapleModel.execute`内で例外が起きる場合specが以上終了してしまう。
例外発生時の後処理のspecを書きたい場合の方法を説明する。

```
it do
  SmapleModel.execute(args) 
  expect(true).to eq true
end
```

## 対応方法
例外が発生する処理の後に`rescue`を書いて例外を握り潰す。

```diff
it do
- SmapleModel.execute(args)
+ SmapleModel.execute(args) rescue
  expect(true).to eq true
end
```

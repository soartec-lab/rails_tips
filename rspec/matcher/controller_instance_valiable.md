# controllerでインスタンス変数の値を確認する場合

`assigns`を使う。

## sample

```
it { expect(assigns[:users]).to include user }
```
# Kernel#itself は以下のような動きをします。

```
$ 1.itself
# => 1

$ 'Hello'.itself
# => 'Hello'

$ object = Object.new
$ object.object_id == object.itself.object_id
# => true
```

要するに self を返してくれるということですね。

# 具体的な利用例

## 配列の値自身で group_by したい場合に綺麗に書くことが出来ます。

```
$ values = [5, 7, 3, 7, 7, 5, 1, 1, 1, 0]

$ # Ruby 2.2.0 未満
$ values.group_by{|x| x}
# => {5=>[5, 5], 7=>[7, 7, 7], 3=>[3], 1=>[1, 1, 1], 0=>[0]}

$ # Ruby 2.2.0 以降
$ values.group_by(&:itself)
# => {5=>[5, 5], 7=>[7, 7, 7], 3=>[3], 1=>[1, 1, 1], 0=>[0]}

## send や sort_by の引数が実行時にしか決まらない場合のデフォルト値として itself を使用することも考えられます。

```
$ values = %w(apple orange BANANA)

# 実行時にソートの条件が決まる.
$ sort_key = :itself
$ sort_key = :length if sort_by_length?
$ sort_key = :upcase if sort_by_upcase?

$ p values.sort_by(&sort_key)
```

## Araayの最頻値を求める

```
$ list = [1,1,1,1,2,2,2,3,2,4,4,4]

$ mode =  list
         .group_by(&:itself)
         .map{ |k,v| [k, v.count] }
         .sort_by {|x| x[1]}
         .last[0]
$ p mode
```

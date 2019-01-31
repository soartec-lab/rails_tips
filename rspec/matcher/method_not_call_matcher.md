# メソッドが呼び出されて**いない**事を確認するマッチャー

```
expect_any_instance_of(Class).not_to receive(:method)
```

## 使い方


```user.rb
Class User

  def hoge
  end

  def huga
  end

end
```

```user_spec.rb

describe User, type: :model do

  it 'User#hugaが呼び出されていない事' do
    (User).not_to receive(:huga)

    User.new.hoge
  end
end
```

## 注意

expect_any_instance_ofを使う場合はactの前で定義する事。

expect_any_instance_ofをactの前に定義しておかないとメソッドのコール数が
正しくカウントされず、間違ったspecを書いてしまう事になります。

```user_spec.rb

describe User, type: :model do

  it 'User#hugaが呼び出されていない事' do
    User.new.hoge

    expect_any_instance_of(User).not_to receive(:huga)
  end
end
```

例えば以下のspecは`User.new.hoge`が呼び出されているのに、specが通ってしまいます。

```user_spec.rb

describe User, type: :model do

  it 'User#hugaが呼び出されていない事' do
    User.new.hoge

    expect_any_instance_of(User).not_to receive(:huge)
  end
end
```
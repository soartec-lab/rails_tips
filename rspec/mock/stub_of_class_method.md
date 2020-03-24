# class methodのstubを定義する

```
before do
  before { allow(User).to receive(:new).and_return("success")
end

User.new => "success"
```

### 例外を発生させたい場合

```
before do
  before { allow(User).to receive(:new).and_raise(StandardError)
end

User.new => StandardError
```

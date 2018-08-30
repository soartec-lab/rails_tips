# shared_examples

テストケースをグループ化する


## リファクタリング前

同一のテストケースが複数存在している

```
describe 'Unshared' do
  let(:b){ true }
  let(:i){ 1 }
  let(:s){ 'hello' }
  context 'in context 1' do
    it "is true" do
      expect(b).to eq(true)
    end
    it "is 1" do
      expect(i).to eq(1)
    end
    it "is hello" do
      expect(s).to eq('hello')
    end
  end
  context 'in context 2' do
    it "is true" do
      expect(b).to eq(true)
    end
    it "is 1" do
      expect(i).to eq(1)
    end
    it "is hello" do
      expect(s).to eq('hello')
    end
  end
end
```

## リファクタリング後

```
describe 'SharedExamples' do
  shared_examples "share me" do
    it "is true" do
      expect(b).to eq(true)
    end
    it "is 1" do
      expect(i).to eq(1)
    end
    it "is hello" do
      expect(s).to eq('hello')
    end
  end
  let(:b){ true }
  let(:i){ 1 }
  let(:s){ 'hello' }
  context 'in context 1' do
    it_behaves_like "share me"
  end
  context 'in context 2' do
    it_behaves_like "share me"
  end
end
```

#　その他
it_behaves_like呼び出し時に引数を渡してshared_example内で使用したりできるそうです。

# 参考
http://samurai.ataglance.jp/rspec_shared_examples/

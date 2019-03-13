# Arrayクラスの要素がuniqueか確認したいけど`PArray#uniq?`がないので拡張する

```
class Array
  # Return whether they array is unique or not
  #
  #  [1, 2, "a", 3].uniq? # => true
  #  [1, 2, "a", 3, "a"].uniq? # => false
  #  [].uniq? # => true
  def uniq?
    uniq == self
  end
end
   
class UniquenessTest < ActiveSupport::TestCase
  def test_uniq?
    assert_equal [1, 2, 3, "a", 4].uniq?, true
    assert_equal [1, 2, 3, "a", 4, "a"].uniq?, false
    assert_equal [].uniq?, true
  end
end
```

# 参考

https://github.com/rails/rails/pull/29371/files
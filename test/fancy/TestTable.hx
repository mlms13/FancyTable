package fancy;

import thx.Tuple;
import utest.Assert;

class TestTable {
  public function new() {}

  public function testFindExistingFolds() {
    var existingFolds = Table.findExistingFolds(new Tuple2(0, 2), new Tuple2(1, 1));
    Assert.same(1, existingFolds.length);
    Assert.same(new Tuple2(0, 2), existingFolds[0]);
  }
}

package test.fancy;

import fancy.Table;
import thx.Tuple;
import utest.Assert;

class TestTable {
  public function new() {}

  public function testFoldIntersection() {
    // overlaps
    Assert.isTrue(Table.foldsIntersect(new Tuple2(0, 3), new Tuple2(1, 5)));
    Assert.isTrue(Table.foldsIntersect(new Tuple2(1, 5), new Tuple2(0, 1)));
    Assert.isTrue(Table.foldsIntersect(new Tuple2(2, 3), new Tuple2(5, 1)));

    // lack of overlaps
    Assert.isFalse(Table.foldsIntersect(new Tuple2(1, 4), new Tuple2(1, 4)));
    Assert.isFalse(Table.foldsIntersect(new Tuple2(1, 4), new Tuple2(0, 5)));
    Assert.isFalse(Table.foldsIntersect(new Tuple2(0, 8), new Tuple2(0, 2)));
    Assert.isFalse(Table.foldsIntersect(new Tuple2(0, 3), new Tuple2(8, 4)));
    Assert.isFalse(Table.foldsIntersect(new Tuple2(1, 7), new Tuple2(3, 1)));
  }
}

package fancy.table.util;

import fancy.table.util.Types;
import thx.Tuple;
import utest.Assert;

class TestNestedData {
  var flatData : Array<RowData>;
  var nestedData : Array<RowData>;

  public function new() {
    flatData = [{
      values : ["a0", "a1", "a2"]
    }, {
      values : ["b0", "b1", "b2"]
    }, {
      values : ["c0", "c1", "c2"]
    }];

    nestedData = [{
      values : ["a"],
      data : [{
        values : ["a.0"],
        data : [{
          values : ["a.0.0"]
        }]
      }, {
        values : ["a.1"],
        data : [{
          values : ["a.1.0"]
        }, {
          values : ["a.1.1"]
        }]
      }]
    }, {
      values : ["b"],
      data : [{
        values : ["b.1"]
      }]
    }];
  }

  public function testIterate() {
    // make sure the returned value matches the number of rows
    Assert.equals(3, NestedData.iterate(flatData, function (_, _) {}));
    Assert.equals(8, NestedData.iterate(nestedData, function (_, _) {}));

    // make sure the correct values are passed to the callback each time
    var count = 0;
    NestedData.iterate(flatData, function (row : RowData, rowIndex : Int) {
      Assert.equals(count, rowIndex);
      Assert.equals(flatData[count].values[0], row.values[0]);
      count++;
    });

    count = 0;
    var values = [];
    NestedData.iterate(nestedData, function (row : RowData, rowIndex : Int) {
      Assert.equals(count, rowIndex);
      values = values.concat(row.values);
      count++;
    });

    Assert.same(["a", "a.0", "a.0.0", "a.1", "a.1.0", "a.1.1", "b", "b.1"], values);
  }

  public function testFoldIntersection() {
    // overlaps
    Assert.isTrue(NestedData.foldsIntersect(new Tuple2(0, 3), new Tuple2(1, 5)));
    Assert.isTrue(NestedData.foldsIntersect(new Tuple2(1, 5), new Tuple2(0, 1)));
    Assert.isTrue(NestedData.foldsIntersect(new Tuple2(2, 3), new Tuple2(5, 1)));

    // lack of overlaps
    Assert.isFalse(NestedData.foldsIntersect(new Tuple2(1, 4), new Tuple2(1, 4)));
    Assert.isFalse(NestedData.foldsIntersect(new Tuple2(1, 4), new Tuple2(0, 5)));
    Assert.isFalse(NestedData.foldsIntersect(new Tuple2(0, 8), new Tuple2(0, 2)));
    Assert.isFalse(NestedData.foldsIntersect(new Tuple2(0, 3), new Tuple2(8, 4)));
    Assert.isFalse(NestedData.foldsIntersect(new Tuple2(1, 7), new Tuple2(3, 1)));
  }
}

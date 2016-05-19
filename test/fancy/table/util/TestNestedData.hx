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
}

using fancy.browser.Dom;
import fancy.Table;
import fancy.table.*;
using thx.Arrays;
using thx.Tuple;

class Main {
  static function main() {
    var el = js.Browser.document.querySelector(".table-container");

    var data : Array<RowData> = [{
      values: ["Cards", "CMC", "Draft Value", "Price"]
    }, {
      values: ["White"],
      data: [{
        values: ["Mythic"],
        data: [{
          values: ["Enchantment"],
          data: [{
            values: ["Quarantine Field", "2", "5", "2.52"]
          }]
        }]
      }, {
        values: ["Rare"],
        data: [{
          values: ["Creature"],
          data: [{
            values: ["Hero of Goma Fada", "5", "3.5", "0.27"]
          }, {
            values: ["Felidar Sovereign", "6", "4", "0.56"]
          }]
        }]
      }]
    }, {
      values: ["Blue"],
      data: [{
        values: ["Mythic"],
        data: [{
          values: ["Sorcery"],
          data: [{
            values: ["Part the Waterveil", "6", "2.0", "1.29"]
          }]
        }]
      }, {
        values: ["Rare"],
        data: [{
          values: ["Creature"],
          data: [{
            values: ["Guardian of Tazeem", "5", "4.5", "0.25"]
          }]
        }]
      }]
    }];

    var table = rectangularize(data).reduce(function(table : Table, curr : Array<String>) {
      var row = curr.reducei(function (row : Row, val : String, index : Int) {
        return row.setCellValue(index, val);
      }, new Row({ colCount : 4 }));

      return table.appendRow(row);
    }, new Table(el));

    createFolds(data)._1.reduce(function (table : Table, fold : Tuple2<Int, Int>) {
      table.rows[fold._0].cells[0].onclick = function (_) {
        table.rows[fold._0].toggle();
      };
      return table.createFold(fold.left, fold.right);
    }, table)
      // TODO: Currently affixing has to be done after setting cell click
      // handlers. Otherwise the cell gets cloned before the handler is set.
      // We could "fix" this by
      .setFixedTop()
      .setFixedLeft();
  }

  // recursively dig through all the rows in the nested data, and return a tuple
  // with the total row count and an array of fold tuples
  static function createFolds(data : Array<RowData>, ?start = 0) {
    return data.reducei(function (acc : Tuple2<Int, Array<Tuple2<Int, Int>>>, row : RowData, index) {
      // always increment the row count
      acc._0++;

      // if there's nested data, dig deep
      if (row.data != null) {
        var result = createFolds(row.data, acc._0 + start);
        acc._1.push(new Tuple2(acc._0 + start - 1, result._0));
        acc._0 += result._0;
        acc._1 = acc._1.concat(result._1);
      }

      return acc;
    }, new Tuple2(0, []));
  }

  static function rectangularize(data : Array<RowData>) : Array<Array<String>> {
    return data.reduce(function (acc : Array<Array<String>>, d : RowData) {
      acc.push(d.values);
      return d.data != null ? acc.concat(rectangularize(d.data)) : acc;
    }, []);
  }
}

typedef RowData = {
  values: Array<String>,
  ?data: Array<RowData>
};

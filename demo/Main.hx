using fancy.browser.Dom;
import fancy.Table;
import fancy.table.*;
using thx.Arrays;

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

    rectangularize(data).reduce(function(table : Table, curr : Array<String>) {
      var row = curr.reducei(function (row : Row, val : String, index : Int) {
        return row.setCellValue(index, val);
      }, new Row(4));

      return table.appendRow(row);
    }, new Table(el))
      .setFixedTop()
      .setFixedLeft();
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

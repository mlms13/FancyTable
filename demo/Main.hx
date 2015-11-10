using fancy.browser.Dom;
import fancy.Table;
import fancy.table.*;
using thx.Arrays;

class Main {
  static function main() {
    var el = js.Browser.document.querySelector(".table-container");

    var data : Array<RowData> = [{
      label: "Color and cards",
      values: ["CMC", "Draft Value", "Price"]
    }, {
      label: "White",
      data: [{
        label: "Mythic",
        data: [{
          label: "Enchantment",
          data: [{
            label: "Quarantine Field",
            values: ["2", "5", "2.52"]
          }]
        }]
      }, {
        label: "Rare",
        data: [{
          label: "Creature",
          data: [{
            label: "Hero of Goma Fada",
            values: ["5", "3.5", "0.27"]
          }, {
            label: "Felidar Sovereign",
            values: ["6", "4", "0.56"]
          }]
        }]
      }]
    }, {
      label: "Blue",
      data: [{
        label: "Mythic",
        data: [{
          label: "Sorcery",
          data: [{
            label: "Part the Waterveil",
            values: ["6", "2.0", "1.29"]
          }]
        }]
      }, {
        label: "Rare",
        data: [{
          label: "Creature",
          data: [{
            label: "Guardian of Tazeem",
            values: ["5", "4.5", "0.25"]
          }]
        }]
      }]
    }];

    data.reduce(function (table : Table, curr : RowData) {
      return table.appendRow(generateRow(curr));
    }, new Table(el));
  }

  static function generateRow(data : RowData) : Row {
    // fix missing values
    data.values = data.values == null ? [] : data.values;

    // make the the first cell, which should always exist
    var headerCell = new Column(data.label);

    // create a new row and fill it with values if they exist
    var row = data.values.reducei(function (acc : Row, curr, index) {
      return acc.setCellValue(index + 1, curr);
    }, new Row([headerCell], 4));

    // wire up the header cell to toggle the row expansion
    headerCell.el.on("click", function (_) {
      row.toggle();
    });

    // return the row with sub-rows appended as necessary
    return  data.data == null ? row : data.data.reduce(function (row : Row, curr : RowData) {
      return row.appendRow(generateRow(curr));
    }, row);
  }
}

typedef RowData = {
  label: String,
  ?data: Array<RowData>,
  ?values: Array<String>
};

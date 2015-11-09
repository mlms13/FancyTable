import fancy.Table;
import fancy.table.*;
using thx.Arrays;

class Main {
  static function main() {
    var el = js.Browser.document.querySelector(".table-container");

    var data : Array<RowData> = [{
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
            label: ""
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
    // fix empty values
    data.values = data.values == null ? [] : data.values;

    // create a new row and fill it with values if they exist
    var row =  data.values.reduce(function (acc : Row, curr) {
      return acc.appendColumn(new Column(curr));
    }, new Row([new Column(data.label)]));

    // return the row with sub-rows appended as necessary
    return row;
    // return  data.data == null ? row : row.addRow(generateRow(data.data));
  }
}

typedef RowData = {
  label: String,
  ?data: Array<RowData>,
  ?values: Array<String>
};

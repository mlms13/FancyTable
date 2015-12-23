using fancy.browser.Dom;
import fancy.Table;
import fancy.table.*;
import fancy.table.util.Types;
import fancy.table.util.NestedData;
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

    var table = Table.createFromNestedData(el, {
      data : data,
      eachFold : function (table, rowIndex) {
        table.rows[rowIndex].cells[0].onclick = function (_) {
          table.rows[rowIndex].toggle();
        }
      }
    })
      // TODO: Currently affixing has to be done after setting cell click
      // handlers. Otherwise the cell gets cloned before the handler is set.
      // We could "fix" this by keeping a reference to each copied cell or
      // by handling event setting at the Table level
      .setFixedTop()
      .setFixedLeft();
  }
}

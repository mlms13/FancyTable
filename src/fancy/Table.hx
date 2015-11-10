package fancy;

import fancy.table.*;
import fancy.table.util.Types;
using fancy.browser.Dom;
import js.html.Element;
using thx.Objects;

class Table {
  var parent : Element;
  var el : Element;
  var options : FancyTableOptions;
  var rows : Array<Row>;

  public function new(parent : Element, ?opts : FancyTableOptions) {
    this.parent = parent;
    this.options = createDefaultOptions(opts);
    rows = [];
    el = Dom.create("div.ft-table");
    parent.appendChild(el);
  }

  function createDefaultOptions(?opts : FancyTableOptions) {
    return Objects.merge({
      colCount : 0
    }, opts == null ? {} : opts);
  }

  public function insertRowAt(index : Int, ?row : Row) : Table {
    row = row == null ? new Row(options.colCount) : row;
    rows.insert(index, row);
    el.insertChildAtIndex(row.el, index);
    return this;
  }

  public function prependRow(?row : Row) : Table {
    return insertRowAt(0, row);
  }

  public function appendRow(?row : Row) : Table {
    return insertRowAt(rows.length, row);
  }

  public function insertColumnAt(index : Int) : Table {
    options.colCount++;
    rows.map(function (row) {
      row.insertColumn(index);
    });
    return this;
  }

  public function prependColumn() : Table {
    return insertColumnAt(0);
  }

  public function appendColumn() : Table {
    return insertColumnAt(options.colCount);
  }
}

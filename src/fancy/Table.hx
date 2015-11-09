package fancy;

import fancy.table.*;
import fancy.table.util.Types;
using fancy.browser.Dom;
import js.html.Element;

class Table {
  var parent : Element;
  var el : Element;
  var rows : Array<Row>;
  var colCount : Int;

  public function new(parent : Element, ?options : FancyTableOptions) {
    this.parent = parent;
    rows = [];
    colCount = 0;
    el = Dom.create("div.ft-table");
    parent.appendChild(el);
  }

  public function insertRowAt(index : Int, ?row : Row) : Table {
    row = row == null ? new Row(colCount) : row;
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
    colCount++;
    rows.map(function (row) {
      row.insertColumn(index);
    });
    return this;
  }

  public function prependColumn() : Table {
    return insertColumnAt(0);
  }

  public function appendColumn() : Table {
    return insertColumnAt(colCount);
  }
}

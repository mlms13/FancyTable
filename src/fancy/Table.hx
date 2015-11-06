package fancy;

import fancy.table.*;
import fancy.table.util.Types;
import fancy.browser.Dom;
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

  public function appendRow() : Table {
    var row = new Row(colCount);

    rows.push(row);
    el.appendChild(row.el);
    return this;
  }

  public function appendColumn() : Table {
    colCount++;
    rows.map(function (row) {
      row.appendColumn();
    });
    return this;
  }
}

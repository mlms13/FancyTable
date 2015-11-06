package fancy;

import fancy.table.*;
import fancy.browserHelpers.Dom;
import js.html.Element;

class Table {
  var parent : Element;
  var el : Element;
  var rows : Array<Row>;

  public function new(parent : Element, options : FancyTableOptions) {
    this.parent = parent;
    rows = [];
    this.el = Dom.create(".fancy-table");
  }

  public function appendRow() : Table {
    rows.push(new Row());
    return this;
  }

  public function appendColumn() : Table {
    return this;
  }
}

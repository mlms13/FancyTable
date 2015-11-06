package fancy.table;

import fancy.browser.Dom;
import js.html.Element;

class Row {
  public var el(default, null) : Element;
  var cols : Array<Column>;

  public function new(?colCount = 0) {
    cols = [];
    this.el = Dom.create("div.ft-row");
    for (i in 0...colCount) appendColumn();
  }

  public function appendColumn(?value) : Column {
    var col = new Column(value);
    cols.push(col);
    el.appendChild(col.el);
    return col;
  }
}

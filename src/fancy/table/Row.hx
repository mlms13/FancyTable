package fancy.table;

using fancy.browser.Dom;
import js.html.Element;

class Row {
  public var el(default, null) : Element;
  var cols : Array<Column>;

  public function new(?colCount = 0) {
    cols = [];
    this.el = Dom.create("div.ft-row");
    for (i in 0...colCount) insertColumn(i);
  }

  public function insertColumn(index : Int, ?value : String) : Column {
    var col = new Column(value);
    cols.insert(index, col);
    el.insertChildAtIndex(col.el, index);
    return col;
  }
}

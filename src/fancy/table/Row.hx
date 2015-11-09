package fancy.table;

using fancy.browser.Dom;
import js.html.Element;
using thx.Arrays;

class Row {
  public var el(default, null) : Element;
  var cols : Array<Column>;

  public function new(?cols : Array<Column>, ?colCount = 0) {
    this.cols = cols == null ? [] : cols;
    this.el = Dom.create("div.ft-row");

    // append all provided columns to this row in the dom
    this.cols.reducei(function (container : Element, col, index) {
      return container.insertChildAtIndex(col.el, index);
    }, this.el);

    // if the total cols is less than the provided count, add more columns
    var colDiff = colCount - this.cols.length;
    if (colDiff > 0) {
      for (i in 0...colDiff) insertColumn(i);
    }
  }

  public function insertColumn(index : Int, ?value : String) : Row {
    var col = new Column(value);
    cols.insert(index, col);
    el.insertChildAtIndex(col.el, index);
    return this;
  }
}

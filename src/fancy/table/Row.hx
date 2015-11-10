package fancy.table;

using fancy.browser.Dom;
import js.html.Element;
using thx.Arrays;

class Row {
  public var el(default, null) : Element;
  var cellsEl : Element;
  var cols : Array<Column>;
  var rows : Array<Row>;

  public function new(?cols : Array<Column>, ?colCount = 0) {
    this.cols = cols == null ? [] : cols;
    this.rows = [];
    cellsEl = Dom.create("div.ft-row-values");
    this.el = Dom.create("div.ft-row", [cellsEl]);

    // append all provided columns to this row in the dom
    this.cols.reducei(function (container : Element, col, index) {
      return container.insertChildAtIndex(col.el, index);
    }, cellsEl);

    // if the total cols is less than the provided count, add more columns
    var colDiff = colCount - this.cols.length;
    if (colDiff > 0) {
      for (i in 0...colDiff) insertColumn(i + this.cols.length);
    }
  }

  public function insertColumn(index : Int, ?col : Column) : Row {
    col = col == null ? new Column() : col;
    cols.insert(index, col);
    cellsEl.insertChildAtIndex(col.el, index);
    return this;
  }

  public function appendColumn(?col : Column) : Row {
    return insertColumn(cols.length, col);
  }

  public function insertRow(index : Int, ?row : Row) : Row {
    row = row == null ? new Row() : row;
    rows.insert(index, row);
    el.insertChildAtIndex(row.el, index);
    return this;
  }

  public function appendRow(?row : Row) : Row {
    return insertRow(rows.length + 1, row);
  }

  public function setCellValue(index : Int, value : String) : Row {
    if (index >= cols.length) {
      return throw 'Cannot set value for cell at index $index, which does not exist';
    }

    cols[index].el.empty().textContent = value;
    return this;
  }
}

package fancy.table;

using fancy.browser.Dom;
import fancy.table.util.Types;
import js.html.Element;
using thx.Arrays;
using thx.Objects;

class Row {
  public var el(default, null) : Element;
  public var rows(default, null) : Array<Row>;
  public var cols(default, null) : Array<Column>;
  var opts : FancyRowOptions;

  public function new(?cols : Array<Column>, ?colCount = 0, ?options : FancyRowOptions) {
    this.cols = cols == null ? [] : cols;
    this.rows = [];
    opts = createDefaultOptions(options);
    opts.classes = createDefaultClasses(opts.classes);
    el = Dom.create("div.ft-row");

    // append all provided columns to this row in the dom
    this.cols.reducei(function (container : Element, col, index) {
      return container.insertChildAtIndex(col.el, index);
    }, el);

    // if the total cols is less than the provided count, add more columns
    var colDiff = colCount - this.cols.length;
    if (colDiff > 0) {
      for (i in 0...colDiff) insertColumn(i + this.cols.length);
    }
  }

  function createDefaultOptions(?options : FancyRowOptions) {
    return Objects.merge({
      expanded : true,
      classes : {},
    }, options == null ? ({} : FancyRowOptions) : options);
  }

  function createDefaultClasses(?classes : FancyRowClasses) : FancyRowClasses {
    return Objects.merge({
      row : "ft-row",
      values : "ft-row-values",
      expanded : "ft-row-expanded",
      collapsed : "ft-row-collapsed",
      foldHeader : "ft-row-fold-header"
    }, classes == null ? {} : classes);
  }

  public function insertColumn(index : Int, ?col : Column) : Row {
    col = col == null ? new Column() : col;
    cols.insert(index, col);
    el.insertChildAtIndex(col.el, index);
    return this;
  }

  public function appendColumn(?col : Column) : Row {
    return insertColumn(cols.length, col);
  }

  public function expand() {
    opts.expanded = true;
    el.removeClass(opts.classes.collapsed).addClass(opts.classes.expanded);
  }

  public function collapse() {
    opts.expanded = false;
    el.removeClass(opts.classes.expanded).addClass(opts.classes.collapsed);
  }

  public function toggle() {
    if (opts.expanded)
      collapse();
    else
      expand();
  }

  public function setCellValue(index : Int, value : String) : Row {
    if (index >= cols.length) {
      return throw 'Cannot set "$value" for cell at index $index, which does not exist';
    }

    cols[index].setValue(value);
    return this;
  }
}

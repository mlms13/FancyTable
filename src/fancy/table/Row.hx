package fancy.table;

using fancy.browser.Dom;
import fancy.table.util.Types;
import js.html.Element;
using thx.Arrays;
using thx.Objects;

class Row {
  public var el(default, null) : Element;
  public var cells(default, null) : Array<Cell>;
  public var indentation(default, null) : Int;
  var rows : Array<Row>;
  var opts : FancyRowOptions;

  public function new(?cells : Array<Cell>, ?colCount = 0, ?options : FancyRowOptions) {
    this.cells = cells == null ? [] : cells;
    opts = createDefaultOptions(options);
    opts.classes = createDefaultClasses(opts.classes);

    rows = [];
    indentation = 0;

    // append all provided cells to this row in the dom
    el = this.cells.reducei(function (container : Element, col, index) {
      return container.insertAtIndex(col.el, index);
    }, Dom.create("div.ft-row"));

    // if the total cell count is less than the provided count, add more cells
    var colDiff = colCount - this.cells.length;
    if (colDiff > 0) {
      for (i in 0...colDiff) insertCell(i + this.cells.length);
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
      foldHeader : "ft-row-fold-header",
      indent : "ft-row-indent-"
    }, classes == null ? {} : classes);
  }

  public function insertCell(index : Int, ?cell : Cell) : Row {
    cell = cell == null ? new Cell() : cell;
    cells.insert(index, cell);
    el.insertAtIndex(cell.el, index);
    return this;
  }

  public function appendCell(?col : Cell) : Row {
    return insertCell(cells.length, col);
  }

  public function addChildRow(child : Row) {
    el.addClass(opts.classes.foldHeader);
    rows.push(child);
  }

  public function indent() {
    el.removeClass('${opts.classes.indent}$indentation');
    indentation++;
    el.addClass('${opts.classes.indent}$indentation');
  }

  public function expand() {
    opts.expanded = true;
    rows.map(function (row) {
      row.el.removeClass(opts.classes.collapsed).addClass(opts.classes.expanded);
    });
  }

  public function collapse() {
    opts.expanded = false;
    rows.map(function (row) {
      row.el.removeClass(opts.classes.expanded).addClass(opts.classes.collapsed);
    });
  }

  public function toggle() {
    if (opts.expanded)
      collapse();
    else
      expand();
  }

  public function setCellValue(index : Int, value : String) : Row {
    if (index >= cells.length) {
      return throw 'Cannot set "$value" for cell at index $index, which does not exist';
    }

    cells[index].setValue(value);
    return this;
  }
}

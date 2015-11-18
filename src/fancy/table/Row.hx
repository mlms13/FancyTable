package fancy.table;

using fancy.browser.Dom;
import fancy.table.util.Types;
import js.html.Element;
using thx.Arrays;
using thx.Functions;
using thx.Ints;
using thx.Objects;

class Row {
  public var el(default, null) : Element;
  var cells : Array<Cell>;
  var indentation : Int;
  var rows : Array<Row>;
  var opts : FancyRowOptions;

  public function new(?cells : Array<Cell>, ?colCount = 0, ?options : FancyRowOptions) {
    this.cells = cells == null ? [] : cells;
    opts = createDefaultOptions(options);
    opts.classes = createDefaultClasses(opts.classes);

    rows = [];
    indentation = 0;

    // append all provided cells to this row in the dom
    el = createRowElement(this.cells);

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
      fixedCellCount : 0,
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

  function createRowElement(?children : Array<Cell>) : Element {
    var childElements = (children != null ? children : []).map.fn(_.el);
    return Dom.create('div.${opts.classes.row}', {}, childElements)
      .addClass('${opts.classes.indent}$indentation')
      .addClass(rows.length == 0 ? "" : opts.classes.foldHeader);
  }

  /**
    Sets the number of fixed cells for this row. This updates the classes on
    all contained rows as necessary and returns a new row element with all of
    the appropriate cells appended to it.
  **/
  public function updateFixedCells(count : Int) : Element {
    // iterate over the difference between the newly-fixed and the previous
    // fixed. fix or unfix as appropriate
    for (i in Ints.min(count, opts.fixedCellCount)...Ints.max(count, opts.fixedCellCount)) {
      cells[i].fixed = count > opts.fixedCellCount;
    }

    opts.fixedCellCount = count;
    return Ints.range(0, count).reduce(function (parent : Element, index) {
      var cell = cells[index].copy();
      cell.fixed = false;
      return parent.append(cell.el);
    }, createRowElement());
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

    cells[index].value = value;
    return this;
  }

  public function copy() {
    return new Row(cells.map.fn(_.copy()), opts);
  }
}

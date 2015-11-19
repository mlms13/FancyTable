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
  var rows : Array<Row>;
  var settings : FancyRowOptions;

  public function new(?cells : Array<Cell>, ?options : FancyRowOptions) {
    this.cells = cells == null ? [] : cells;
    settings = createDefaultOptions(options);
    settings.classes = createDefaultClasses(settings.classes);

    rows = [];

    // append all provided cells to this row in the dom
    el = createRowElement(this.cells);

    // if the total cell count is less than the provided count, add more cells
    var colDiff = settings.colCount - this.cells.length;
    if (colDiff > 0) {
      for (i in 0...colDiff) insertCell(i + this.cells.length);
    }
  }

  function createDefaultOptions(?options : FancyRowOptions) {
    return Objects.merge({
      classes : {},
      colCount : 0,
      expanded : true,
      fixedCellCount : 0,
      indentation : 0
    }, options == null ? ({} : FancyRowOptions) : options);
  }

  function createDefaultClasses(?classes : FancyRowClasses) : FancyRowClasses {
    return Objects.merge({
      row : "ft-row",
      values : "ft-row-values",
      expanded : "ft-row-expanded",
      collapsed : "ft-row-collapsed",
      foldHeader : "ft-row-fold-header",
      hidden : "ft-row-hidden",
      indent : "ft-row-indent-"
    }, classes == null ? {} : classes);
  }

  function createRowElement(?children : Array<Cell>) : Element {
    var childElements = (children != null ? children : []).map.fn(_.el);
    return Dom.create('div.${settings.classes.row}', {}, childElements)
      .addClass(settings.expanded ? settings.classes.expanded : settings.classes.collapsed)
      .addClass('${settings.classes.indent}${settings.indentation}')
      .addClass(rows.length == 0 ? "" : settings.classes.foldHeader);
  }

  /**
    Sets the number of fixed cells for this row. This updates the classes on
    all contained rows as necessary and returns a new row element with all of
    the appropriate cells appended to it.
  **/
  public function updateFixedCells(count : Int) : Element {
    // iterate over the difference between the newly-fixed and the previous
    // fixed. fix or unfix as appropriate
    for (i in Ints.min(count, settings.fixedCellCount)...Ints.max(count, settings.fixedCellCount)) {
      cells[i].fixed = count > settings.fixedCellCount;
    }

    settings.fixedCellCount = count;
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
    el.addClass(settings.classes.foldHeader);
    rows.push(child);
  }

  public function indent() {
    el.removeClass('${settings.classes.indent}${settings.indentation}');
    settings.indentation++;
    el.addClass('${settings.classes.indent}${settings.indentation}');
  }

  public function expand() {
    settings.expanded = true;
    el.removeClass(settings.classes.collapsed).addClass(settings.classes.expanded);
    rows.map(function (row) {
      row.el.removeClass(settings.classes.hidden);
    });
  }

  public function collapse() {
    settings.expanded = false;
    el.removeClass(settings.classes.expanded).addClass(settings.classes.collapsed);
    rows.map(function (row) {
      row.el.addClass(settings.classes.hidden);
    });
  }

  public function toggle() {
    if (settings.expanded)
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
    return new Row(cells.map.fn(_.copy()), settings);
  }
}

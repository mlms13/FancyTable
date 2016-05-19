package fancy.table;

using dots.Dom;
import fancy.table.util.Types;
import fancy.table.util.CellContent;
import js.html.Element;
using thx.Arrays;
using thx.Functions;
using thx.Ints;
using thx.Objects;

class Row {
  public var el(default, null) : Element;
  public var cells(default, null) : Array<Cell>;
  var rows : Array<Row>;
  var settings : FancyRowOptions;
  var fixedEl : Element;

  public function new(?cells : Array<Cell>, ?options : FancyRowOptions) {
    this.cells = cells == null ? [] : cells;
    settings = createDefaultOptions(options);
    settings.classes = createDefaultClasses(settings.classes);

    rows = [];

    // append all provided cells to this row in the dom
    el = createRowElement(this.cells);

    // if the total cell count is less than the provided count, add more cells
    var colDiff = Ints.max(0, settings.colCount - this.cells.length);
    fillWithCells(colDiff);
  }

  function createDefaultOptions(?options : FancyRowOptions) {
    return Objects.merge({
      classes : {},
      colCount : 0,
      expanded : true,
      hidden : false,
      fixedCellCount : 0,
      indentation : 0
    }, options == null ? ({} : FancyRowOptions) : options);
  }

  function createDefaultClasses(?classes : FancyRowClasses) : FancyRowClasses {
    return Objects.merge({
      row : "ft-row",
      expanded : "ft-row-expanded",
      collapsed : "ft-row-collapsed",
      foldHeader : "ft-row-fold-header",
      hidden : "ft-row-hidden",
      indent : "ft-row-indent-",
      custom : ([] : Array<String>)
    }, classes == null ? {} : classes);
  }

  function createRowElement(?children : Array<Cell>) : Element {
    var childElements = (children != null ? children : []).map.fn((_.el : js.html.Node));
    var classes = [
      settings.classes.row,
      settings.expanded ? settings.classes.expanded : settings.classes.collapsed,
      '${settings.classes.indent}${settings.indentation}',
    ].concat(settings.classes.custom);

    if (settings.hidden) classes.push(settings.classes.hidden);
    if (rows.length > 0) classes.push(settings.classes.foldHeader);

    return classes.reduce(Dom.addClass, Dom.create("div", childElements));
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
    fixedEl = Ints.range(0, count).reduce(function (parent : Element, index) {
      var cell = cells[index].copy();
      cell.fixed = false;
      return parent.append(cell.el);
    }, createRowElement());

    return fixedEl;
  }

  public function insertCell(index : Int, ?cell : Cell) : Row {
    cell = cell == null ? new Cell() : cell;
    cells.insert(index, cell);
    el.insertAtIndex(cell.el, index);
    return this;
  }

  function addRowClass(className : String) {
    el.addClass(className);
    if (fixedEl != null)
      fixedEl.addClass(className);
    return this;
  }

  function removeRowClass(className : String) {
    el.removeClass(className);
    if (fixedEl != null)
      fixedEl.removeClass(className);
    return this;
  }

  public function setCustomClasses(classes : Array<String>) {
    settings.classes.custom.each(removeRowClass);
    settings.classes.custom = classes;
    classes.each(addRowClass);
    return this;
  }

  public function appendCell(?col : Cell) : Row {
    return insertCell(cells.length, col);
  }

  public function fillWithCells(howMany : Int) : Row {
    return 0.range(howMany).reduce(function (_, _) {
      return appendCell();
    }, this);
  }

  public function addChildRow(child : Row) {
    addRowClass(settings.classes.foldHeader);
    rows.push(child);
  }

  public function removeChildRow(child : Row) {
    rows.remove(child);
    if (rows.length == 0) {
      removeRowClass(settings.classes.foldHeader);
    }
  }

  public function indent() {
    removeRowClass('${settings.classes.indent}${settings.indentation}');
    settings.indentation++;
    addRowClass('${settings.classes.indent}${settings.indentation}');
  }

  public function expand() {
    settings.expanded = true;
    removeRowClass(settings.classes.collapsed).addRowClass(settings.classes.expanded);
    rows.map.fn(_.show());
  }

  public function collapse() {
    settings.expanded = false;
    removeRowClass(settings.classes.expanded).addRowClass(settings.classes.collapsed);
    rows.map.fn(_.hide());
  }

  public function toggle() {
    if (settings.expanded)
      collapse();
    else
      expand();
  }

  function hide() {
    settings.hidden = true;

    // any time a row is hidden, make sure its children are also hidden
    rows.map.fn(_.hide());
    return addRowClass(settings.classes.hidden);
  }

  public function show() {
    settings.hidden = false;

    // and when a row is shown, if that row is also expanded, show the children
    if (settings.expanded) {
      rows.map.fn(_.show());
    }
    return removeRowClass(settings.classes.hidden);
  }

  /**
    Sets the value of a cell given the 0-based index of the cell. Cells can have
    strings, numbers, or html elements as content.
  **/
  public function setCellValue(index : Int, value : CellContent) : Row {
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

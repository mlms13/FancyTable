package fancy;

import fancy.Grid;
import fancy.table.Row;
using fancy.table.util.NestedData;
import fancy.table.util.Types;
import fancy.table.util.CellContent;
using dots.Dom;
import js.html.Element;
import js.html.Node;
using thx.Arrays;
using thx.Functions;
import thx.Functions.fn;
import thx.Ints;
using thx.Objects;
using thx.Options;
using thx.Tuple;

/**
  Create a new FancyTable by instantiating the `Table` class. A table instance
  provides you with read-only access to its rows, as well as methods for adding
  rows, modifying data, creating folds, and more. Instance methods generally
  return the instance of the table for easy chaining.
**/
class Table {
  public var rows(default, null) : Array<Row> = [];
  var settings : FancyTableOptions;
  var maxColumns: Int;
  var grid : Grid;
  var folds : Array<Tuple2<Int, Int>>;

  /**
    A container element must be provided to the constructor. You may also
    provide an options object, though the only property you may wish to set with
    this object is the initial data.
  **/
  public function new(parent : Element, ?options : FancyTableOptions) {
    maxColumns = 0;
    settings = createDefaultOptions(options);
    settings.classes = createDefaultClasses(settings.classes);

    // fill with any data
    setData(settings.data);

    // create the grid
    grid = new Grid(parent, {
      rows: rows.length,
      columns: maxColumns,
      render: renderGrid,
      fixedLeft: settings.fixedLeft,
      fixedTop: settings.fixedTop
    });
  }

  function createDefaultOptions(?options : FancyTableOptions) : FancyTableOptions {
    return Objects.merge({
      classes: {},
      colCount: 0,
      fixedTop: 0,
      fixedLeft: 0,
      data: Tabular([])
    }, options == null ? ({} : FancyTableOptions) : options);
  }

  function createDefaultClasses(?classes : FancyTableClasses) {
    return Objects.merge({
      table : "ft-table",
      scrollH : "ft-table-scroll-horizontal",
      scrollV : "ft-table-scroll-vertical"
    }, classes == null ? {} : classes);
  }

  function empty() : Table {
    // grid.empty(); TODO
    rows = [];
    folds = [];
    this.settings.data = Nested([]);
    maxColumns = 0;
    return this;
  }

  function renderGrid(row: Int, col: Int): Element {
    // TODO: expose the fallback cellcontent through the options
    var fallback: CellContent = "";
    return rows.getOption(row).flatMap.fn(_.renderCell(col)).getOrElse(CellContent.render(fallback));
  }

  /**
    Fills the table with entirely new data. This method completely empties the
    table and creates new rows and columns given the provided data.

    Note that this will remove any existing folds and fixed headers. It will
    also empty all table elements from the DOM and recreate them.
  **/
  public function setData(data: FancyTableData): Table {
    return switch data {
      case Tabular(d): setTabularData(this.empty(), d);
      case Nested(d): setNestedData(this.empty(), d);
    };
  }

  static function setTabularData(table: Table, data: Array<Array<CellContent>>): Table {
    return data.reduce(function(t: Table, curr: Array<CellContent>) {
      return t.appendRow(new Row(curr));
    }, table);
  }

  static function setNestedData(table: Table, data: Array<RowData>): Table {
    return appendRowsWithChildren(table, data.toRows());
  }

  static function appendRowsWithChildren(table: Table, newRows: Array<Row>) {
    return newRows.reduce(function (t: Table, row) {
      t.appendRow(row);
      return appendRowsWithChildren(t, row.rows);
    }, table);
  }

  /**
    Inserts a new row at any given index. If no row is provided, an empty row
    will be created.

    Note that for now, the inserted row won't obey any existing fixed row/col
    instructions you provided. If possible, add all rows before setting fixed
    headers.
  **/
  function insertRowAt(index : Int, row : Row) : Table {
    // TODO: if you're inserting a row within the range of the affixed header
    // rows, we need to re-create the header table
    // ALSO TODO: we need to grab the first n cells in the new row and add them
    // to the affixed header column table (where n = number of affixed cells)

    // if our new row has more cells than everybody else, increase our count
    maxColumns = Ints.max(maxColumns, row.cells.length);

    rows.insert(index, row);

    // TODO: grid needs a way to add rows? no. kind of.
    // grid.content.insertAtIndex(row.el, index);
    return this;
  }

  /**
    Inserts a new row before all existing rows. If no row is provided, an empty
    row will be created.

    TODO: in the following couple functions, whose job is it to tell the table
    to re-render? We don't want `insertRowAt` to do it, because then it will get
    hit over and over again and we run `setNestedData`. We don't want this
    function to do it, because we've built these in a way to support chaining.
    Maybe we expose a re-render function to the user, so they can:
      .prepend(row1).append(row2).prepend(row3).redraw()
  **/
  public inline function prependRow(row: Row): Table
    return insertRowAt(0, row);

  /**
    Inserts a new row after all existing rows. If no row is provided, an empty
    row will be created.
  **/
  public inline function appendRow(row: Row): Table
    return insertRowAt(rows.length, row);

  /**
    Sets the value of a cell given the 0-based index of the row and the 0-based
    index of the cell within that row. Cells can have strings, numbers, or html
    elements as content.

    TODO: who uses this, and does it really make sense for them to know about
    the index of these things? What about indexes that are out of range?
  **/
  public function setCellValue(row : Int, cell : Int, value : CellContent) : Table {
    rows[row].setCellValue(cell, value);
    return this;
  }
}

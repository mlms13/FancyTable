package fancy;

import js.html.Element;

using thx.Arrays;
using thx.Functions;
import thx.Ints;
using thx.Options;

import fancy.table.FancyTableSettings;
import fancy.table.Row;
import fancy.table.util.CellContent;
import fancy.table.util.FancyTableOptions;
using fancy.table.util.NestedData;
import fancy.table.util.RowData;

import fancy.Grid;

enum FancyTableData {
  Tabular(data : Array<Array<CellContent>>);
  Nested(data : Array<RowData>);
}

/**
  Create a new FancyTable by instantiating the `Table` class. A table instance
  provides you with read-only access to its rows, as well as methods for adding
  rows, modifying data, creating folds, and more. Instance methods generally
  return the instance of the table for easy chaining.
**/
class Table {
  var settings(default, null): FancyTableSettings;
  var grid(default, null): Grid;
  var rows(default, null): Array<Row> = [];
  var visibleRows(default, null): Array<Row> = [];
  var maxColumns(default, null): Int = 0;

  /**
    A container element must be provided to the constructor. You may also
    provide an options object, though the only property you may wish to set with
    this object is the initial data.
  **/
  public function new(parent: Element, data: FancyTableData, ?options: FancyTableOptions) {
    settings = FancyTableSettings.fromOptions(options);

    // create the grid
    grid = new Grid(parent, {
      // FIXME: these counts get immediately reset by the `setData` function
      // we have to default them to non-zero things for now because FancyGrid
      // fails otherwise
      rows: 1,
      columns: 3,
      render: renderGridCell,
      fixedLeft: settings.fixedLeft,
      fixedTop: settings.fixedTop,
      vSize: assignVSize,
      hSize: function (col: Int) {
        return settings.hSize(col, maxColumns);
      },
      onScroll: settings.onScroll,
      onResize: settings.onResize
    });

    // fill with any data
    setData(data);
  }

  function assignVSize(row: Int): CellDimension {
    return visibleRows.getOption(row).cata(Fixed(0), function (r: Row) {
      return r.height;
    });
  }

  function renderGridCell(row: Int, col: Int): Element {
    return visibleRows.getOption(row).flatMap.fn(_.renderCell(this, row, col))
      .getOrElse(settings.fallbackCell.render("ft-cell-content", this, row, col));
  }

  /**
    Fills the table with entirely new data. This method completely empties the
    table and creates new rows and columns given the provided data.

    Note that this will remove any existing folds and fixed headers. It will
    also empty all table elements from the DOM and recreate them.
  **/
  public function setData(data: FancyTableData, resetScroll = true): Table {
    // convert the new data to rows
    var newRows = switch data {
      case Tabular(d): d.map.fn(new Row(_, settings.classes, RenderSmart));
      case Nested(d): d.toRows(settings.classes);
    };

    // empty the current table and set new rows
    rows = [];
    maxColumns = 0;
    newRows.reduce(tableAppendRow, this);
    resetVisibleRowsAndRedraw();

    if (resetScroll)
      this.resetScroll();

    return this;
  }

  public function resetScroll() : Void {
    grid.scrollTo(settings.initialScrollX, settings.initialScrollY);
  }

  public function resetScrollX() : Void {
    grid.scrollTo(settings.initialScrollX, null);
  }

  public function resetScrollY() : Void {
    grid.scrollTo(null, settings.initialScrollY);
  }

  inline function resetVisibleRowsAndRedraw() : Void {
    visibleRows = flattenVisibleRows(rows);
    grid.setRowsAndColumns(Ints.max(visibleRows.length, 1), Ints.max(maxColumns, 1));
  }

  static function flattenVisibleRows(rows: Array<Row>): Array<Row> {
    return rows.reduce(function (acc: Array<Row>, r) {
      var children = r.expanded ? r.rows : [];
      return acc.append(r).concat(flattenVisibleRows(children));
    }, []);
  }

  /**
    Inserts a new row at any given index. If no row is provided, an empty row
    will be created.

    Note that for now, the inserted row won't obey any existing fixed row/col
    instructions you provided. If possible, add all rows before setting fixed
    headers.
  **/
  static function insertRowAt(table: Table, index: Int, newRow: Row): Table {
    // TODO: if you're inserting a row within the range of the affixed header
    // rows, we need to re-create the header table
    // ALSO TODO: we need to grab the first n cells in the new row and add them
    // to the affixed header column table (where n = number of affixed cells)

    // if our new row has more cells than everybody else, increase our count
    table.maxColumns = Ints.max(table.maxColumns, newRow.cells.length);
    table.rows.insert(index, newRow);
    return table;
  }

  /**
    Inserts a new row before all existing rows. If no row is provided, an empty
    row will be created.

    TODO: in the following couple functions, whose job is it to tell the table
    to re-render? We don't want `insertRowAt` to do it, because then it will get
    hit over and over again and we refresh with `setData`. We don't want this
    function to do it, because we've built these in a way to support chaining.
    Maybe we expose a re-render function to the user, so they can:
      .prepend(row1).append(row2).prepend(row3).redraw()

    This only becomes an issue if we make these guys public again
  **/
  static inline function prependRow(table: Table, row: Row): Table
    return insertRowAt(table, 0, row);

  // Inserts a new row after all existing rows.
  static inline function tableAppendRow(table: Table, row: Row): Table
    return insertRowAt(table, table.rows.length, row);


  /**
    Switch a row's folded state between collapsed an expanded. The index
    provided to this function should be its index in the rendered table, not its
    index among all rows (some of which may be collapsed and hidden). The index
    needed here will match the index provided to a CellContent's `render()`.
  **/
  public function toggleRow(index: Int) : Void {
    visibleRows.getOption(index).map(function(r) {
      r.toggle();
      resetVisibleRowsAndRedraw();
    });
  }

  /**
    Sets the value of a cell given the 0-based index of the row and the 0-based
    index of the cell within that row. Cells can have strings, numbers, or html
    elements as content.

    TODO: re-enable, but figure out whose job it is to re-render after calling
    this, and figure out how to validate indexes that are out of range
  **/
  // function setCellValue(row: Int, cell: Int, value: CellContent): Table {
  //   rows[row].setCellValue(cell, value);
  //   return this;
  // }
}

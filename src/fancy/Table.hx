package fancy;

import fancy.Grid;
import fancy.table.*;
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
  var settings: FancyTableSettings;
  var grid: Grid;
  var rows: Array<Row> = [];
  var visibleRows: Array<Row> = [];
  var maxColumns: Int = 0;

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
      render: renderGrid,
      fixedLeft: settings.fixedLeft,
      fixedTop: settings.fixedTop
    });

    // fill with any data
    setData(data);
  }

  function renderGrid(row: Int, col: Int): Element {
    // TODO: expose the fallback cellcontent through the options
    return visibleRows.getOption(row).flatMap.fn(_.renderCell(this, row, col))
      .getOrElse(Dom.create("span", ""));
  }

  /**
    Fills the table with entirely new data. This method completely empties the
    table and creates new rows and columns given the provided data.

    Note that this will remove any existing folds and fixed headers. It will
    also empty all table elements from the DOM and recreate them.
  **/
  public function setData(data: FancyTableData): Table {
    switch data {
      case Tabular(d): setTabularData(this, d);
      case Nested(d): setNestedData(this, d);
    };

    resetVisibleRowsAndRedraw();
    return this;
  }

  static inline function setTabularData(table: Table, data: Array<Array<CellContent>>): Table
    return data.map.fn(new Row(_)).reduce(tableAppendRow, table);

  static inline function setNestedData(table: Table, data: Array<RowData>): Table
    return data.toRows().reduce(tableAppendRow, table);

  inline function resetVisibleRowsAndRedraw() {
    visibleRows = flattenVisibleRows(rows);
    grid.setRowsAndColumns(visibleRows.length, maxColumns);
  }

  static function flattenVisibleRows(rows: Array<Row>): Array<Row> {
    return rows.reduce(function (acc: Array<Row>, r) {
      var children = r.settings.expanded ? r.rows : [];
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

    // TODO: grid needs a way to add rows? no. kind of.
    // grid.content.insertAtIndex(row.el, index);
    return table;
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
  public function toggleRow(index: Int) {
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

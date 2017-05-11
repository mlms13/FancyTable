package fancy;

import js.html.Element;

using thx.Arrays;
import thx.Ints;

import haxe.ds.Option;
using thx.Functions;
using thx.Options;

import fancy.table.CellEvent;
import fancy.table.Coords;
import fancy.table.FancyTableSettings;
import fancy.table.KeyEvent;
import fancy.table.RangeEvent;
import fancy.table.ResizeEvent;
import fancy.table.Row;
import fancy.table.Range;
import fancy.table.ScrollEvent;
import fancy.table.util.CellContent;
import fancy.table.util.FancyTableOptions;
using fancy.table.util.NestedData;
import fancy.table.util.RowData;
import js.html.*;

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
  var settings: FancyTableSettings;
  var grid: Grid;
  var rows: Array<Row> = [];
  var visibleRows: Array<Row> = [];
  var maxColumns: Int = 0;
  public var selection(default, null): Option<Range>;
  public var hasFocus(default, null): Bool;
  public var bottomRight(default, null): Coords;

  /**
    A container element must be provided to the constructor. You may also
    provide an options object, though the only property you may wish to set with
    this object is the initial data.
  **/
  public function new(parent: Element, data: FancyTableData, ?options: FancyTableOptions) {
    settings = FancyTableSettings.fromOptions(options);
    selection = Options.ofValue(options.selection).map.fn(new fancy.table.Range(new Coords(_.minRow, _.minCol), new Coords(_.maxRow, _.maxCol)));

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
      onScroll: function(x, y, ox, oy) settings.onScroll(new ScrollEvent(this, x, y, ox, oy)),
      onResize: function(x, y, ox, oy) settings.onResize(new ResizeEvent(this, x, y, ox, oy)),
    });

    // fill with any data
    setData(data);

    wireEvents(parent);
  }

  function wireEvents(el: Element) {
    // focus related events
    if(settings.focusOnHover) {
      el.addEventListener("mouseenter", focus, false);
      el.addEventListener("mouseleave", blur, false);
    } else {
      el.addEventListener("mousedown", function(e: MouseEvent) {
        e.preventDefault();
        focus();
      }, false);
      js.Browser.document.addEventListener("mousedown", blur, false);
    }
    if(settings.selectionEnabled) {
      var counter = 0,
          cancel = function(){};
      el.addEventListener("click", function(e: MouseEvent) {
        if(++counter == 1) {
          cancel = thx.Timer.delay(function() counter = 0, 400);
          // single click is managed by mousedown
          // singleClick(e);
        } else if(counter == 2) {
          // double click
          dblClick(e);
        } else {
          counter = 0;
          cancel();
        }
      }, false);
      el.addEventListener("mousedown", function(e: MouseEvent) {
        e.preventDefault();
        beginDrag(e);
        js.Browser.document.addEventListener("mousemove", mouseMove, false);
        js.Browser.document.addEventListener("mouseup", mouseUp, false);
      });
      js.Browser.document.addEventListener("keydown", keyDown, false);
    } else {
      el.addEventListener("dblclick", dblClick, false);
    }
  }

  function mouseMove(e: MouseEvent) {
    e.preventDefault();
    dragging(e);
  }

  function mouseUp(e: MouseEvent) {
    js.Browser.document.removeEventListener("mousemove", mouseMove, false);
    js.Browser.document.removeEventListener("mouseup", mouseUp, false);
    e.preventDefault();
  }

  function keyDown(e: KeyboardEvent) {
    if(!hasFocus) return;
    pressKey(KeyEvent.fromKeyboardEvent(this, e));
  }

  function dblClick(e: MouseEvent) {
    getCoords(cast e.target)
      .each(coords -> settings.onDoubleClick(new CellEvent(this, coords)));
  }

  function beginDrag(e: MouseEvent) {
    if(e.shiftKey) {
      selectToCoords(e.target);
    } else {
      selectAtCoords(e.target);
    }
  }

  function dragging(e: MouseEvent) {
    selectToCoords(e.target);
  }

  function selectAtCoords(target: js.html.EventTarget) {
    getCoords(cast target)
      .each.fn(select(_.row, _.col))
      .each(coords -> settings.onClick(new CellEvent(this, coords)));
  }

  function selectToCoords(target: js.html.EventTarget) {
    getCoords(cast target)
      .each.fn(selectCurrentToCell(_.row, _.col));
  }

  function getCoords(el: Element): Option<Coords> {
    var cell = dots.Query.closest(el, "div.cell");
    if(null == cell) return None; // NOT FOUND, weird
    var row = Std.parseInt(cell.getAttribute("data-row")),
        col = Std.parseInt(cell.getAttribute("data-col"));
    return Some(new Coords(row, col));
  }

  function getCoordsIfNotActive(el: Element): Option<Coords> {
    return getCoords(el)
      .flatMap(c -> matchActive(c.row, c.col) ? None: Some(c));
  }

  public function pressKey(e: KeyEvent) {
    switch e.key.toLowerCase() {
      case "home":
        e.preventDefault();
        if(e.shift && settings.rangeSelectionEnabled)
          selectToFirstColumn();
        else
          goFirstColumn();
      case "end":
        e.preventDefault();
        if(e.shift && settings.rangeSelectionEnabled)
          selectToLastColumn();
        else
          goLastColumn();
      case "pageup":
        e.preventDefault();
        if(e.shift && settings.rangeSelectionEnabled)
          selectPageUp();
        else
          goPageUp();
      case "pagedown":
        e.preventDefault();
        if(e.shift && settings.rangeSelectionEnabled)
          selectPageDown();
        else
          goPageDown();
      case "enter":
        e.preventDefault();
        if(e.shift)
          goPrevious();
        else
          goNext();
      case "tab":
        e.preventDefault();
        if(e.shift)
          goPreviousHorizontal();
        else
          goNextHorizontal();
      case "arrowdown":
        e.preventDefault();
        if(e.shift && settings.rangeSelectionEnabled) {
          // is selection
          if(e.isCmdOnMacOrCtrl()) {
            selectToLastRow();
          } else {
            selectDown();
          }
        } else {
          // is movement
          if(e.isCmdOnMacOrCtrl()) {
            goLastRow();
          } else {
            goDown();
          }
        }
      case "arrowup":
        e.preventDefault();
        if(e.shift && settings.rangeSelectionEnabled) {
          // is selection
          if(e.isCmdOnMacOrCtrl()) {
            selectToFirstRow();
          } else {
            selectUp();
          }
        } else {
          // is movement
          if(e.isCmdOnMacOrCtrl()) {
            goFirstRow();
          } else {
            goUp();
          }
        }
      case "arrowleft":
        e.preventDefault();
        if(e.shift && settings.rangeSelectionEnabled) {
          // is selection
          if(e.isCmdOnMacOrCtrl()) {
            selectToFirstColumn();
          } else {
            selectLeft();
          }
        } else {
          // is movement
          if(e.isCmdOnMacOrCtrl()) {
            goFirstColumn();
          } else {
            goLeft();
          }
        }
      case "arrowright":
        e.preventDefault();
        if(e.shift && settings.rangeSelectionEnabled) {
          // is selection
          if(e.isCmdOnMacOrCtrl()) {
            selectToLastColumn();
          } else {
            selectRight();
          }
        } else {
          // is movement
          if(e.isCmdOnMacOrCtrl()) {
            goLastColumn();
          } else {
            goRight();
          }
        }
      case _:
    }
    settings.onKey(e);
  }

  public function resetCacheForRange(minRow:Int, minCol: Int, maxRow: Int, maxCol: Int)
    grid.resetCacheForRange(minRow, minCol, maxRow, maxCol);

  public function renderCell(row: Int, col: Int, content: CellContent) {
    visibleRows
      .getOption(row)
      .map(function(r) {
        var el = content.render(r.classSettings.cellContent, this, row, col);
        return r.renderCellContainer([], el, row, col);
      })
      .each(function(el) {
        grid.patchCellContent(row, col, el);
      });
  }

  public function select(row: Int, col: Int) {
    selectRange(row, col, row, col, row, col);
  }

  public function goFirst()
    selectRange(0, 0, 0, 0, 0, 0);

  public function goFirstColumn() {
    selectFromRange.fn(_.firstColumn());
  }
  public function goLastColumn() {
    var last = grid.columns - 1;
    selectFromRange.fn(_.goToColumn(last));
  }
  public function goFirstRow() {
    selectFromRange.fn(_.firstRow());
  }
  public function goLastRow() {
    var last = grid.rows - 1;
    selectFromRange.fn(_.goToRow(last));
  }
  public function goPageUp() {
    selectFromRange.fn(_.upRows(10)); // TODO !!!
  }
  public function goPageDown() {
    var last = grid.rows - 1;
    selectFromRange.fn(_.downRows(10, last)); // TODO !!!
  }

  public function goNextHorizontal() selectFromRange.fn(_.nextHorizontal());
  public function goPreviousHorizontal() selectFromRange.fn(_.previousHorizontal());
  public function goNext() selectFromRange.fn(_.next());
  public function goPrevious() selectFromRange.fn(_.previous());
  public function goLeft() selectFromRange.fn(_.left());
  public function goRight() selectFromRange.fn(_.right());
  public function goUp() selectFromRange.fn(_.up());
  public function goDown() selectFromRange.fn(_.down());

  public function selectToFirstColumn() {
    selectFromRange.fn(_.selectToFirstColumn());
    scrollToCol(0);
  }
  public function selectToLastColumn() {
    var last = grid.columns - 1;
    selectFromRange.fn(_.selectToColumn(last));
    scrollToCol(last);
  }
  public function selectToFirstRow() {
    selectFromRange.fn(_.selectToFirstRow());
    scrollToRow(0);
  }
  public function selectToLastRow() {
    var last = grid.rows - 1;
    selectFromRange.fn(_.selectToRow(last));
    scrollToRow(last);
  }
  public function selectPageUp() {
    selectFromRange.fn(_.selectUpRows(10)); // TODO !!!
  }
  public function selectPageDown() {
    var last = grid.rows - 1;
    selectFromRange.fn(_.selectDownRows(10, last)); // TODO !!!
  }

  public function selectCurrentToCell(row: Int, col: Int) {
    selectFromRange.fn(_.selectCurrentToCell(row, col));
    scrollToCell(row, col);
  }

  function selectFromRange(f: Range -> Range) {
    switch selection {
      case None:
        goFirst();
      case Some(range):
        selectWithRange(f(range));
    }
  }

  public function selectLeft() {
    var left = getRange(r -> r.selectLeft());
    selectWithRange(left);
    switch selection {
      case Some(r):
        if(r.active.col > r.min.col)
          scrollToCol(r.min.col);
        else
          scrollToCol(r.max.col);
      case None: // do nothing
    }
  }
  public function selectRight() {
    var right = getRange(r -> r.selectRight());
    selectWithRange(right);
    switch selection {
      case Some(r):
        if(r.active.col < r.max.col)
          scrollToCol(r.max.col);
        else
          scrollToCol(r.min.col);
      case None: // do nothing
    }
  }
  public function selectUp() {
    var up = getRange(r -> r.selectUp());
    selectWithRange(up);
    switch selection {
      case Some(r):
        if(r.active.row > r.min.row)
          scrollToRow(r.min.row);
        else
          scrollToRow(r.max.row);
      case None: // do nothing
    }
  }
  public function selectDown() {
    var down = getRange(r -> r.selectDown());
    selectWithRange(down);
    switch selection {
      case Some(r):
        if(r.active.row < r.max.row)
          scrollToRow(r.max.row);
        else
          scrollToRow(r.min.row);
      case None: // do nothing
    }
  }

  function getRange(f: Range -> Range) {
    return switch selection {
      case None: new Range(new Coords(0, 0), new Coords(0, 0));
      case Some(r): f(r);
    };
  }


  public function selectWithRange(range: Range) {
    selectRange(range.min.row, range.min.col, range.max.row, range.max.col, range.active.row, range.active.col);
  }

  public function selectRange(minRow: Int, minCol: Int, maxRow: Int, maxCol: Int, ?row: Int = 0, ?col: Int = 0) {
    if(!settings.selectionEnabled) return;
    if(!settings.rangeSelectionEnabled) {
      maxRow = minRow;
      maxCol = minCol;
    }

    if(minRow < 0 || minCol < 0) return; // negative values
    if(maxRow >= bottomRight.row || maxCol >= bottomRight.col) return; // out of bounds

    var range = new Range(new Coords(minRow, minCol), new Coords(maxRow, maxCol));
    range.active.row = row;
    range.active.col = col;

    switch selection {
      case Some(old) if(old.equals(range)): return; // range has not changed
      case _:
    }

    switch selection {
      case Some(range):
        grid.resetCacheForRange(range.min.row, range.min.col, range.max.row, range.max.col);
      case None: // do nothing
    }

    var oldRange = selection;
    selection = Some(range);

    grid.resetCacheForRange(range.min.row, range.min.col, range.max.row, range.max.col);
    scrollToCell(row, col);
    settings.onRangeChange(new RangeEvent(this, oldRange, selection));
  }

  public function deselect() {
    switch selection {
      case Some(range):
        grid.resetCacheForRange(range.min.row, range.min.col, range.max.row, range.max.col);
      case None: // do nothing
    }
    var oldRange = selection;
    selection = None;
    settings.onRangeChange(new RangeEvent(this, oldRange, selection));
  }

  function scrollToCell(row: Int, col: Int) {
    grid.scrollTo(Visible(Cells(col)), Visible(Cells(row)));
  }

  function scrollToRow(row: Int) {
    grid.scrollTo(null, Visible(Cells(row)));
  }

  function scrollToCol(col: Int) {
    grid.scrollTo(Visible(Cells(col)), null);
  }

  function assignVSize(row: Int): CellDimension {
    return visibleRows.getOption(row).cata(Fixed(0), function (r: Row) {
      return r.height;
    });
  }

  function matchActive(row: Int, col: Int): Bool {
    return switch selection {
      case Some(range) if(range.active.row != row || range.active.col != col):
        false;
      case Some(_):
        true;
      case None:
        false;
    };
  }

  function renderGridCell(row: Int, col: Int): Element {
    var classes = [];
    return visibleRows.getOption(row)
      .flatMap.fn(_.renderCell(this, row, col, classes))
      .getOrElse(settings.fallbackCell.render(["ft-cell-content"].concat(classes).join(" "), this, row, col));
  }

  public function focus() {
    if(hasFocus) return;
    hasFocus = true;
    settings.onFocus(this);
  }

  public function blur() {
    if(!hasFocus) return;
    hasFocus = false;
    settings.onBlur(this);
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
      case Tabular(d): d.map.fn(new Row(this, _, settings.classes, RenderSmart));
      case Nested(d): d.toRows(this, settings.classes);
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

  public function refresh() : Void {
    grid.scrollTo(null, null);
  }

  public function getScrollPosition() : { x: Float, y: Float } {
    return grid.getScrollPosition();
  }

  public function scrollToPosition(?x : Float, ?y : Float) : Void {
    grid.scrollToPosition(x, y);
  }

  public function scrollTo(?xPos: HorizontalScrollPosition, ?yPos: VerticalScrollPosition) : Void {
    grid.scrollTo(xPos, yPos);
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
    bottomRight = new Coords(visibleRows.length, maxColumns);
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

  public function destroy() {
    js.Browser.document.removeEventListener("mousedown", blur, false);
    js.Browser.document.removeEventListener("keydown", keyDown, false);
    js.Browser.document.removeEventListener("mousemove", mouseMove, false);
    js.Browser.document.removeEventListener("mouseup", mouseUp, false);
  }
}

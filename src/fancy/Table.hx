package fancy;

import fancy.table.*;
import fancy.table.util.Types;
using fancy.browser.Dom;
import js.html.Element;
using thx.Arrays;
using thx.Functions;
using thx.Ints;
using thx.Objects;
using thx.Tuple;

class Table {
  public var rows(default, null) : Array<Row>;
  var settings : FancyTableOptions;
  var grid : GridContainer;
  var folds : Array<Tuple2<Int, Int>>;

  // ints to track how many rows/cols are fixed in various places
  var fixedTop : Int;
  var fixedLeft : Int;

  public function new(parent : Element, ?options : FancyTableOptions) {
    var tableEl : Element;
    this.settings = createDefaultOptions(options);
    rows = [];
    folds = [];
    fixedTop = 0;
    fixedLeft = 0;

    // create lots of dom
    tableEl = Dom.create("div.ft-table");
    grid = new GridContainer();
    tableEl.appendChild(grid.grid);

    // and fix the scrolling
    tableEl.on("scroll", function (_) {
      grid.positionPanes(tableEl.scrollTop, tableEl.scrollLeft);
    });

    // and add all of our shiny new dom to the parent
    parent.appendChild(tableEl);
  }

  function createDefaultOptions(?options : FancyTableOptions) {
    return Objects.merge({
      colCount : 0
    }, options == null ? {} : options);
  }

  public function insertRowAt(index : Int, ?row : Row) : Table {
    // TODO: if you're inserting a row within the range of the affixed header
    // rows, we need to re-create the header table
    // ALSO TODO: we need to grab the first n cells in the new row and add them
    // to the affixed header column table (where n = number of affixed cells)
    row = row == null ? new Row({colCount : settings.colCount}) : row;

    // if our new row has fewer cols than everybody else, fill it
    row.fillWithCells(Ints.max(0, settings.colCount - row.cells.length));

    // but if it has more than everybody else, fill those and increase our count
    setColCount(row.cells.length);

    rows.insert(index, row);
    grid.content.insertAtIndex(row.el, index);
    return this;
  }

  public function prependRow(?row : Row) : Table {
    return insertRowAt(0, row);
  }

  public function appendRow(?row : Row) : Table {
    return insertRowAt(rows.length, row);
  }

  function setColCount(howMany : Int) {
    if (howMany > settings.colCount) {
      rows.map(function(row) {
        row.fillWithCells(howMany - settings.colCount);
      });

      settings.colCount = howMany;
    }
  }

  public function setFixedTop(?howMany = 1) : Table {
    // TODO: if howmany < the previous value, the hidden cells in the previously
    // hidden rows will not show up. we need to go through and clean up
    for (i in Ints.min(howMany, fixedTop)...Ints.max(howMany, fixedTop)) {
      // rows[i]
      // cells[i].fixed = howMany > fixedTop;
    }

    // empty existing fixed-row table
    grid.top
      .empty()
      .append(0.range(howMany).map(function (i) {
        return rows[i].copy().el;
      }));

    fixedTop = howMany;
    return updateFixedTopLeft();
  }

  public function setFixedLeft(?howMany = 1) : Table {
    grid.left
      .empty()
      .append(rows.map(function (row) {
        return row.updateFixedCells(howMany);
      }));

    fixedLeft = howMany;
    return updateFixedTopLeft();
  }

  function updateFixedTopLeft() : Table {
    grid.topLeft
      .empty()
      .append(0.range(fixedTop).map(function (i) {
        return rows[i].copy().updateFixedCells(fixedLeft);
      }));
    return this;
  }

  public static function foldsIntersect(a : Tuple2<Int, Int>, b: Tuple2<Int, Int>) : Bool {
    // sort by the index of the header
    var first = a._0 <= b._0 ? a : b,
        second = first == a ? b : a;

    return first._0 < second._0 && // no problem if they start at the same spot
           second._0 <= first._0 + first._1 && // or if second starts after the end of first
           second._0 + second._1 > first._0 + first._1; // or if second ends before first ends
  }

  public function createFold(headerIndex : Int, childrenCount : Int) {
    // check for out-of-range indexes
    if (headerIndex >= rows.length)
      return throw 'Cannot set fold point at $headerIndex because there are only ${rows.length} rows';

    childrenCount = Ints.min(childrenCount, rows.length - headerIndex);

    // folds can contain others, but they can't partially overlap
    for (fold in folds) {
      if (fold._0 == headerIndex) {
        return throw 'Cannot set fold point at $headerIndex because that row is already a fold header';
      }
      if (foldsIntersect(fold, new Tuple2(headerIndex, childrenCount))) {
        return throw 'Cannot set fold point at $headerIndex because it intersects with an existing fold';
      }
    }

    // finally, if we've made it this far, set up the fold
    for (i in (headerIndex + 1)...(childrenCount + headerIndex + 1)) {
      rows[i].indent();
      rows[headerIndex].addChildRow(rows[i]);
    }
    folds.push(new Tuple2(headerIndex, childrenCount));

    return setFixedLeft(fixedLeft);
  }
}

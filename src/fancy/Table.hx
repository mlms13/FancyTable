package fancy;

import fancy.table.*;
import fancy.table.util.Types;
using fancy.browser.Dom;
import js.html.Element;
import js.html.Node;
using thx.Arrays;
using thx.Objects;

class Table {
  var options : FancyTableOptions;
  var rows : Array<Row>;
  var grid : GridContainer;

  // ints to track how many rows/cols are fixed in various places
  var fixedTop : Int;
  var fixedLeft : Int;

  public function new(parent : Element, ?opts : FancyTableOptions) {
    var tableEl : Element;
    this.options = createDefaultOptions(opts);
    rows = [];
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

  function createDefaultOptions(?opts : FancyTableOptions) {
    return Objects.merge({
      colCount : 0
    }, opts == null ? {} : opts);
  }

  public function insertRowAt(index : Int, ?row : Row) : Table {
    // TODO: if you're inserting a row within the range of the affixed header
    // rows, we need to re-create the header table
    // ALSO TODO: we need to grab the first n cells in the new row and add them
    // to the affixed header column table (where n = number of affixed cells)
    row = row == null ? new Row(options.colCount) : row;
    rows.insert(index, row);
    grid.content.insertChildAtIndex(row.el, index);
    return this;
  }

  public function prependRow(?row : Row) : Table {
    return insertRowAt(0, row);
  }

  public function appendRow(?row : Row) : Table {
    return insertRowAt(rows.length, row);
  }

  public function insertColumnAt(index : Int) : Table {
    options.colCount++;
    rows.map(function (row) {
      row.insertColumn(index);
    });
    return this;
  }

  public function prependColumn() : Table {
    return insertColumnAt(0);
  }

  public function appendColumn() : Table {
    return insertColumnAt(options.colCount);
  }

  // recursively dig through rows, finding the cells we need to affix
  function fixColumns(howMany : Int, rows : Array<Row>) : Array<Node> {
    return rows.reducei(function (acc : Array<Node>, row, index) {
      var newRow = row.cols.reducei(function (newRow : Row, col, index) {
        if (index < howMany) {
          newRow.appendColumn(new Column(col.value));
          col.el.addClass("ft-col-fixed");
        } else {
          col.el.removeClass("ft-col-fixed");
        }
        return newRow;
      }, new Row());

      acc.push(newRow.el);
      acc = acc.concat(fixColumns(howMany, row.rows));
      return acc;
    }, []);
  }

  public function setFixedTop(?howMany = 1) : Table {
    // empty existing fixed-row table
    grid.top.empty();

    // TODO: if howmany < the previous value, the hidden cells in the previously
    // hidden rows will not show up. we need to go through and clean up

    // ANOTHER TODO: if we consistenly update the colcount, we won't have to
    // dig into the rows to find the number of columns here
    fixColumns(rows[0].cols.length, rows.slice(0, howMany)).reduce(function (acc, child) {
      acc.appendChild(child);
      return acc;
    }, grid.top);

    fixedTop = howMany;
    return updateFixedTopLeft();
  }

  public function setFixedLeft(?howMany = 1) : Table {
    grid.left.empty();

    var children = fixColumns(howMany, rows);
    children.reduce(function (acc, child) {
      acc.appendChild(child);
      return acc;
    }, grid.left);

    fixedLeft = howMany;
    return updateFixedTopLeft();
  }

  function updateFixedTopLeft() : Table {
    grid.topLeft.empty();

    var cells = fixColumns(fixedLeft, rows.slice(0, fixedTop));

    cells.reduce(function (acc, child) {
      acc.appendChild(child);
      return acc;
    }, grid.topLeft);
    return this;
  }
}

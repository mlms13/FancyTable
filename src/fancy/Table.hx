package fancy;

import fancy.table.*;
import fancy.table.util.Types;
using fancy.browser.Dom;
import js.html.Element;
using thx.Arrays;
using thx.Objects;

class Table {
  var tableEl : Element;
  var options : FancyTableOptions;
  var rows : Array<Row>;
  var grid : GridContainer;

  public function new(parent : Element, ?opts : FancyTableOptions) {
    this.options = createDefaultOptions(opts);
    rows = [];

    // create lots of dom
    tableEl = Dom.create("div.ft-table");
    grid = new GridContainer();
    tableEl.appendChild(grid.grid);
    parent.appendChild(tableEl);

    // and fix the scrolling
    tableEl.on("scroll", function (_) {
      grid.positionPanes(tableEl.scrollTop, tableEl.scrollLeft);
    });
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
    tableEl.insertChildAtIndex(row.el, index);
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

  public function setFixedRow(?howMany = 1) : Table {
    // empty existing fixed-row table
    grid.top.empty();

    // fill that table with `howMany` rows, cloned from the regular table
    rows.reducei(function (acc : Element, row : Row, index) {
      if (index < howMany) {
        //mark the real rows for easy hiding
        acc.appendChild(row.el.cloneNode(true));
        row.el.addClass("ft-row-fixed-header");
      } else {
        row.el.removeClass("ft-row-fixed-header");
      }
      return acc;
    }, grid.top);

    return this;
  }
}

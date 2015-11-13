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

  public function new(parent : Element, ?opts : FancyTableOptions) {
    var tableEl : Element;
    this.options = createDefaultOptions(opts);
    rows = [];

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

  public function setFixedTop(?howMany = 1) : Table {
    // empty existing fixed-row table
    grid.top.empty();

    // fill that table with `howMany` rows, cloned from the regular table
    rows.reducei(function (acc : Element, row : Row, index) {
      if (index < howMany) {
        //mark the real rows for easy hiding
        acc.appendChild(row.el.cloneNode(true));
        row.el.addClass("ft-row-fixed");
      } else {
        row.el.removeClass("ft-row-fixed");
      }
      return acc;
    }, grid.top);

    return this;
  }

  function fixColumns(howMany : Int, rows : Array<Row>) : Array<Node> {
    return rows.reducei(function (acc : Array<Node>, row, index) {
      var valuesEl = row.cols.reducei(function (newRow : Element, col, index) {
        if (index < howMany) {
          newRow.appendChild(col.el.cloneNode(true));
          col.el.addClass("ft-col-fixed");
        } else {
          col.el.removeClass("ft-col-fixed");
        }
        return newRow;
      }, Dom.create("div.ft-row-values"));

      acc.push(Dom.create("div.ft-row", [valuesEl]));
      acc = acc.concat(fixColumns(howMany, row.rows));
      return acc;
    }, []);
  }

  public function setFixedLeft(?howMany = 1) : Table {
    grid.left.empty();

    var children = fixColumns(howMany, rows);
    children.reduce(function (acc, child) {
      acc.appendChild(child);
      return acc;
    }, grid.left);
    return this;
  }
}

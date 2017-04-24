package fancy.table.util;

import fancy.table.Row;
import fancy.table.FancyTableSettings;
using thx.Arrays;

typedef ChildRows = { children : Array<Row>, allRows : Array<Row> };

class NestedData {
  /**
    Converts a nested `RowData` structure into a flat array of array of strings,
    which can be used to set complete table data from scratch.
  **/
  public static function rectangularize(data : Array<RowData>) : Array<Array<CellContent>> {
    return data.reduce(function (acc : Array<Array<CellContent>>, d : RowData) {
      acc.push(d.values);
      return d.data != null ? acc.concat(rectangularize(d.data)) : acc;
    }, []);
  }

  /**
    Recursively iterates over the nested data in the given array of `RowData`,
    calling the provided callback function for each value. The callback receives
    the `RowData` value at this point, as well as the total count of rows that
    have been encountered so far.
  **/
  public static function iterate(data : Array<RowData>, fn : RowData -> Int -> Void, ?start = 0) {
    return data.reduce(function (acc : Int, row : RowData) {
      fn(row, acc);

      acc++;
      return row.data != null ? iterate(row.data, fn, acc) : acc;
    }, start);
  }

  /**
    Builds rows and cells for all of the RowData, returning an array of nested
    Row objects (each with 0 or more Row children).
  **/
  public static function toRows(data: Array<RowData>, classes: FancyTableClasses, indentation = 0): Array<Row> {
    return data.reduce(function (acc: Array<Row>, curr: RowData) {
      if (curr.meta == null) curr.meta = {};
      if (curr.data == null) curr.data = [];
      if (curr.meta.height == null) curr.meta.height = RenderSmart;

      var newRow = new Row(curr.values, classes, curr.meta.height, curr.meta.classes, curr.meta.expanded, indentation);

      if (curr.data.length > 0)
        newRow.addChildRows(toRows(curr.data, classes, indentation + 1));

      return acc.append(newRow);
    }, []);
  }
}

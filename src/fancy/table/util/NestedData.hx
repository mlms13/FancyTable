package fancy.table.util;

import fancy.table.Cell;
import fancy.table.Row;
import fancy.table.util.Types;
using thx.Arrays;
using thx.Functions;
import thx.Tuple;

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
  public static function toRows(data : Array<RowData>, indentation = 0, ?eachFold : Row -> Void) : Array<Row> {
    return data.reduce(function (acc : Array<Row>, curr : RowData) {
      var newRow = new Row(curr.values.map.fn(new Cell(_)));
      newRow.setIndentation(indentation);

      var childRows = curr.data != null ?
        toRows(curr.data, indentation + 1, eachFold) : [];

      if (childRows.length > 0) {
        newRow.addChildRows(childRows);

        // TODO: this shouldn't be optional, but we have no way to currently
        // handle this in fancygrid
        if (eachFold != null) eachFold(newRow);
      }

      // apply any information stored in meta
      if (curr.meta != null) {
        if (curr.meta.classes != null)
          newRow.setCustomClasses(curr.meta.classes);
        if (curr.meta.collapsed == true)
          newRow.collapse();
      }

      return acc.concat([newRow]);
    }, []);
  }
}

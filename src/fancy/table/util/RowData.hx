package fancy.table.util;

import fancy.Grid;

typedef RowData = {
  values : Array<CellContent>,
  ?data : Array<RowData>,
  ?meta : {
    ?classes : Array<String>,
    ?expanded : Bool,
    ?height: CellDimension
  }
};

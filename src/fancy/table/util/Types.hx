package fancy.table.util;

import fancy.Grid;

typedef FancyTableOptions = {
  ?fixedTop: Int,
  ?fixedLeft: Int,
  ?fallbackCell: CellContent,
  ?classes: FancyTableClassOptions,
  ?hSize: Int -> Int -> CellDimension
};

typedef FancyTableClassOptions = {
  ?cellContent: String,
  ?rowExpanded: String,
  ?rowCollapsed: String,
  ?rowFoldHeader: String,
  ?rowIndent: String
};

typedef RowData = {
  values : Array<CellContent>,
  ?data : Array<RowData>,
  ?meta : {
    ?classes : Array<String>,
    ?expanded : Bool,
    ?height: CellDimension
  }
};

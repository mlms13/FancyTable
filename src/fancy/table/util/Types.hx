package fancy.table.util;

typedef FancyTableOptions = {
  ?fixedTop: Int,
  ?fixedLeft: Int,
  ?fallbackCell: CellContent,
  ?classes: FancyTableClassOptions
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
    ?collapsed : Bool
  }
};

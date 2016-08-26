package fancy.table.util;

enum FancyTableData {
  Tabular(data : Array<Array<CellContent>>);
  Nested(data : Array<RowData>);
}

typedef FancyTableOptions = {
  ?fixedTop: Int,
  ?fixedLeft: Int
};

typedef FancyRowOptions = {
  ?classes: FancyRowClasses,
  ?expanded: Bool,
  ?indentation: Int
};

typedef FancyRowClasses = {
  ?row : String,
  ?expanded : String,
  ?collapsed : String,
  ?foldHeader : String,
  ?indent : String,
  ?custom : Array<String>
};

typedef RowData = {
  values : Array<CellContent>,
  ?data : Array<RowData>,
  ?meta : {
    ?classes : Array<String>,
    ?collapsed : Bool
  }
};

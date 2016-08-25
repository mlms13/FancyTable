package fancy.table.util;

enum FancyTableData {
  Tabular(data : Array<Array<CellContent>>);
  Nested(data : Array<RowData>);
}

typedef FancyTableOptions = {
  ?classes: FancyTableClasses,
  ?colCount: Int,
  ?data: FancyTableData,
  ?fixedTop: Int,
  ?fixedLeft: Int
};

typedef FancyTableClasses = {
  ?table : String,
  ?scrollH : String,
  ?scrollV : String
};

typedef FancyRowOptions = {
  ?classes : FancyRowClasses,
  ?colCount : Int,
  ?expanded : Bool,
  ?fixedCellCount : Int,
  ?indentation : Int
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

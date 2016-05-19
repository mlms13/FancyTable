package fancy.table.util;

typedef FancyTableOptions = {
  ?classes : FancyTableClasses,
  ?colCount : Int,
  ?data : Array<Array<CellContent>>
};

typedef FancyTableClasses = {
  ?table : String,
  ?scrollH : String,
  ?scrollV : String
};

typedef FancyNestedTableOptions = {
  data : Array<RowData>,
  ?colCount : Int,
  ?eachFold : Row -> Void
}

typedef FancyRowOptions = {
  ?classes : FancyRowClasses,
  ?colCount : Int,
  ?expanded : Bool,
  ?hidden : Bool,
  ?fixedCellCount : Int,
  ?indentation : Int
};

typedef FancyRowClasses = {
  ?row : String,
  ?expanded : String,
  ?collapsed : String,
  ?foldHeader : String,
  ?hidden : String,
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

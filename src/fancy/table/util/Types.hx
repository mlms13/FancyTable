package fancy.table.util;

typedef FancyTableOptions = {
  ?colCount : Int,
  ?data : Array<Array<String>>
};

typedef FancyNestedTableOptions = {
  data : Array<RowData>,
  ?colCount : Int,
  ?eachFold : fancy.Table -> Int -> Void
}

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
  ?hidden : String,
  ?indent : String,
  ?custom : String
};

typedef RowData = {
  values : Array<String>,
  ?data : Array<RowData>,
  ?meta : {
    ?classes : Array<String>
  }
};

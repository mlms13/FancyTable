package fancy.table.util;

typedef FancyTableOptions = {
  ?colCount : Int,
  ?data : Array<Array<String>>
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
  ?hidden : String,
  ?indent : String
};

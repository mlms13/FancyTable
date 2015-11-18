package fancy.table.util;

typedef FancyTableOptions = {
  ?colCount : Int
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
  ?values : String,
  ?expanded : String,
  ?collapsed : String,
  ?foldHeader : String,
  ?indent : String
};

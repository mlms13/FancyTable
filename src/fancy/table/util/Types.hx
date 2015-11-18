package fancy.table.util;

typedef FancyTableOptions = {
  ?colCount : Int
};

typedef FancyRowOptions = {
  ?expanded : Bool,
  ?classes : FancyRowClasses,
  ?fixedCellCount : Int
};

typedef FancyRowClasses = {
  ?row : String,
  ?values : String,
  ?expanded : String,
  ?collapsed : String,
  ?foldHeader : String,
  ?indent : String
};

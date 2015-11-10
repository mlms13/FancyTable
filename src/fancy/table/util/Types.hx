package fancy.table.util;

typedef FancyTableOptions = {
  ?colCount : Int
};

typedef FancyRowOptions = {
  ?expanded : Bool,
  ?classes : FancyRowClasses
};

typedef FancyRowClasses = {
  ?row : String,
  ?values : String,
  ?expanded : String,
  ?collapsed : String,
  ?withChildren : String
};

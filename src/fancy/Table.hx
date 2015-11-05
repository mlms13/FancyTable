package fancy;

import fancy.table.*;

class Table {
  var rows : Array<Row>;

  public function new() {
    rows = [];
  }

  public function appendRow() : Table {
    rows.push(new Row());
    return this;
  }

  public function appendColumn() : Table {
    return this;
  }

  public function render() {

  }
}

package fancy.table;

class Coords {
  @:isVar public var row(get, set): Int;
  @:isVar public var col(get, set): Int;
  public function new(row: Int, col: Int) {
    this.row = row;
    this.col = col;
  }

  public function matches(row: Int, col: Int)
    return this.row == row && this.col == col;

  public function toString()
    return '{row:$row, col:$col}';

  public function equals(b: Coords)
    return row == b.row && col == b.col;

  function get_row() return row;
  function get_col() return col;
  function set_row(v: Int) return row = v;
  function set_col(v: Int) return col = v;
}

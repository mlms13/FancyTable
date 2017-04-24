package fancy.table;

class Range {
  public var min(default, null): Coords;
  public var max(default, null): Coords;
  public var active(default, null): Coords;
  public function new(min: Coords, max: Coords) {
    this.min = min;
    this.max = max;
    this.active = new ActiveCoords(this, min.row, min.col);
  }

  public function contains(row: Int, col: Int) {
    return row >= min.row && row <= max.row && col >= min.col && col <= max.col;
  }

  public function isActive(row: Int, col: Int) {
    return active.matches(row, col);
  }

  public function isOnLeft(col: Int) {
    return min.col == col;
  }

  public function isOnRight(col: Int) {
    return max.col == col;
  }

  public function isOnTop(row: Int) {
    return min.row == row;
  }

  public function isOnBottom(row: Int) {
    return max.row == row;
  }
}

class ActiveCoords extends Coords {
  var range: Range;
  public function new(range: Range, row: Int, col: Int) {
    this.range = range;
    super(row, col);
  }

  override function set_row(v: Int) {
    if(v < range.min.row) v = range.min.row;
    else if(v > range.max.row) v = range.max.row;
    return super.set_row(v);
  }

  override function set_col(v: Int) {
    if(v < range.min.col) v = range.min.col;
    else if(v > range.max.col) v = range.max.col;
    return super.set_col(v);
  }
}

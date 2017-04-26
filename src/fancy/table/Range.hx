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

  public function toString() {
    return '(${min.row},${min.col}x${max.row},${max.col}-${active.row},${active.col})';
  }

  public function next() {
    if(rows() == 1 && cols() == 1)
      return down();
    if(activeRow() == rows() -1 && activeCol() == cols() - 1) { // last position
      var range = new Range(min, max);
      range.active.row = min.row;
      range.active.col = min.col;
      return range;
    } else if(activeRow() < rows() - 1) {
      var range = new Range(min, max);
      range.active.row = active.row + 1;
      range.active.col = active.col;
      return range;
    } else {
      var range = new Range(min, max);
      range.active.row = min.row;
      range.active.col = active.col + 1;
      return range;
    }
  }

  public function previous() {
    if(rows() == 1 && cols() == 1)
      return up();
    if(activeRow() == 0 && activeCol() == 0) { // first position
      var range = new Range(min, max);
      range.active.row = max.row;
      range.active.col = max.col;
      return range;
    } else if(activeRow() > 0) {
      var range = new Range(min, max);
      range.active.row = active.row - 1;
      range.active.col = active.col;
      return range;
    } else {
      var range = new Range(min, max);
      range.active.row = max.row;
      range.active.col = active.col - 1;
      return range;
    }
  }

  public function nextHorizontal() {
    if(rows() == 1 && cols() == 1)
      return right();
    if(activeRow() == rows() -1 && activeCol() == cols() - 1) { // last position
      var range = new Range(min, max);
      range.active.row = min.row;
      range.active.col = min.col;
      return range;
    } else if(activeCol() == cols() - 1) {
      var range = new Range(min, max);
      range.active.row = active.row + 1;
      range.active.col = min.col;
      return range;
    } else {
      var range = new Range(min, max);
      range.active.row = active.row;
      range.active.col = active.col + 1;
      return range;
    }
  }

  public function previousHorizontal() {
    if(rows() == 1 && cols() == 1)
      return left();
    if(activeRow() == 0 && activeCol() == 0) { // first position
      var range = new Range(min, max);
      range.active.row = max.row;
      range.active.col = max.col;
      return range;
    } else if(activeCol() == 0) {
      var range = new Range(min, max);
      range.active.row = active.row - 1;
      range.active.col = max.col;
      return range;
    } else {
      var range = new Range(min, max);
      range.active.row = active.row;
      range.active.col = active.col - 1;
      return range;
    }
  }

  public function left() {
    var coord = new Coords(active.row, active.col - 1);
    return new Range(coord, coord); // TODO !!!
  }

  public function right() {
    var coord = new Coords(active.row, active.col + 1);
    return new Range(coord, coord); // TODO !!!
  }

  public function up() {
    var coord = new Coords(active.row - 1, active.col);
    return new Range(coord, coord); // TODO !!!
  }

  public function down() {
    var coord = new Coords(active.row + 1, active.col);
    return new Range(coord, coord); // TODO !!!
  }

  public function selectLeft() {
    var range = if(cols() == 1 || activeCol() > 0) {
      // expand on the left
      new Range(new Coords(min.row, min.col - 1), max);
    } else {
      // contract on the right
      new Range(min, new Coords(max.row, max.col - 1));
    }
    range.active.row = active.row;
    range.active.col = active.col;
    return range;
  }

  public function selectRight() {
    var range = if(cols() == 1 || activeCol() < cols() - 1) {
      // expand on the right
      new Range(min, new Coords(max.row, max.col + 1));
    } else {
      // contract on the left
      new Range(new Coords(min.row, min.col + 1), max);
    }
    range.active.row = active.row;
    range.active.col = active.col;
    return range;
  }

  public function selectUp() {
    var range = if(rows() == 1 || activeRow() > 0) {
      // expand on the left
      new Range(new Coords(min.row - 1, min.col), max);
    } else {
      // contract on the right
      new Range(min, new Coords(max.row - 1, max.col));
    }
    range.active.row = active.row;
    range.active.col = active.col;
    return range;
  }

  public function selectDown() {
    var range = if(rows() == 1 || activeRow() < rows() - 1) {
      // expand on the right
      new Range(min, new Coords(max.row + 1, max.col));
    } else {
      // contract on the left
      new Range(new Coords(min.row + 1, min.col), max);
    }
    range.active.row = active.row;
    range.active.col = active.col;
    return range;
  }

  public function rows() {
    return max.row - min.row + 1;
  }

  public function cols() {
    return max.col - min.col + 1;
  }

  public function activeRow()
    return active.row - min.row;
  public function activeCol()
    return active.col - min.col;

  public function equals(b: Range) {
    return min.equals(b.min) && max.equals(b.max) && active.equals(b.active);
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

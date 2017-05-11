package fancy.table;

class ScrollEvent {
  public var table(default, null): Table;
  public var x(default, null): Float;
  public var y(default, null): Float;
  public var oldX(default, null): Float;
  public var oldY(default, null): Float;

  public function new(table: Table, x: Float, y: Float, oldX: Float, oldY: Float) {
    this.table = table;
    this.x = x;
    this.y = y;
    this.oldX = oldX;
    this.oldY = oldY;
  }

  public function toString() {
    return 'x: $x, y: $y, oldX: $oldX, oldY: $oldY';
  }
}

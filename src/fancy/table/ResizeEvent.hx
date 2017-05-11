package fancy.table;

class ResizeEvent {
  public var table(default, null): Table;
  public var width(default, null): Float;
  public var height(default, null): Float;
  public var oldWidth(default, null): Float;
  public var oldHeight(default, null): Float;

  public function new(table: Table, width: Float, height: Float, oldWidth: Float, oldHeight: Float) {
    this.table = table;
    this.width = width;
    this.height = height;
    this.oldWidth = oldWidth;
    this.oldHeight = oldHeight;
  }

  public function toString() {
    return 'width: $width, height: $height, oldWidth: $oldWidth, oldHeight: $oldHeight';
  }
}

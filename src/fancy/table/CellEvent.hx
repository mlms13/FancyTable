package fancy.table;

class CellEvent {
  public var table(default, null): Table;
  public var coords(default, null): Coords;

  public function new(table: Table, coords: Coords) {
    this.table = table;
    this.coords = coords;
  }

  public function toString() {
    return coords.toString();
  }
}

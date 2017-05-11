package fancy.table;

import haxe.ds.Option;

class RangeEvent {
  public var table(default, null): Table;
  public var oldRange(default, null): Option<Range>;
  public var newRange(default, null): Option<Range>;

  public function new(table: Table, oldRange: Option<Range>, newRange: Option<Range>) {
    this.table = table;
    this.oldRange = oldRange;
    this.newRange = newRange;
  }
}

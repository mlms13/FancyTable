package fancy.table;

import fancy.table.util.Types;
import fancy.table.util.CellContent;

class FancyTableSettings {
  public var fixedTop(default, null): Int;
  public var fixedLeft(default, null): Int;
  public var fallbackCell(default, null): CellContent;

  function new(fixedTop, fixedLeft, fallbackCell) {
    this.fixedTop = fixedTop;
    this.fixedLeft = fixedLeft;
    this.fallbackCell = fallbackCell;
  }

  public static function fromOptions(?opts: FancyTableOptions) {
    if (opts == null) opts = {};

    return new FancyTableSettings(
      opts.fixedTop != null ? opts.fixedTop : 0,
      opts.fixedLeft != null ? opts.fixedLeft : 0,
      opts.fallbackCell != null ? opts.fallbackCell : CellContent.fromString("")
    );
  }
}

package fancy.table;

import fancy.table.util.Types;

class FancyTableSettings {
  public var fixedTop(default, null): Int;
  public var fixedLeft(default, null): Int;

  function new(fixedTop, fixedLeft) {
    this.fixedTop = fixedTop;
    this.fixedLeft = fixedLeft;
  }

  public static function fromOptions(?opts: FancyTableOptions) {
    if (opts == null) opts = {};

    return new FancyTableSettings(
      opts.fixedTop != null ? opts.fixedTop : 0,
      opts.fixedLeft != null ? opts.fixedLeft : 0
    );
  }
}

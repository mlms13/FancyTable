package fancy.table;

import haxe.ds.Option;
using thx.Options;

class KeyEvent {
  public static function fromKeyboardEvent(table: Table, e: js.html.KeyboardEvent) {
    return new KeyEvent(
      table,
      e.key, e.altKey, e.ctrlKey, e.shiftKey, e.metaKey,
      e.isChar,
      e.which,
      e.stopPropagation, e.preventDefault,
      () -> e.defaultPrevented
    );
  }

  public var table(default, null): Table;

  public var key(default, null): String;
  public var alt(default, null): Bool;
  public var ctrl(default, null): Bool;
  public var shift(default, null): Bool;
  public var meta(default, null): Bool;
  public var isChar(default, null): Bool;
  public var which(default, null): Int;
  public var stopPropagation(default, null): Void -> Void;
  public var preventDefault(default, null): Void -> Void;
  public var defaultPrevented(default, null): Void -> Bool;
  public var coords(get, never): Option<Coords>;

  public function new(table: Table, key: String, alt: Bool, ctrl: Bool, shift: Bool, meta: Bool, isChar: Bool, which: Int, stopPropagation: Void -> Void, preventDefault: Void -> Void, defaultPrevented: Void -> Bool) {
    this.table = table;
    this.key = key;
    this.alt = alt;
    this.ctrl = ctrl;
    this.shift = shift;
    this.meta = meta;
    this.isChar = isChar;
    this.which = which;
    this.stopPropagation = stopPropagation;
    this.preventDefault = preventDefault;
    this.defaultPrevented = defaultPrevented;
  }

  public static var isMac(default, null): Bool = js.Browser.navigator.platform.toUpperCase().indexOf('MAC')>=0;

  public function isCmdOnMacOrCtrl() {
    if(!ctrl && !meta) return false;
    return (isMac && meta) || (!isMac && ctrl);
  }

  public function toString() {
    var acc = [];
    if(alt) acc.push("alt");
    if(ctrl) acc.push("ctrl");
    if(shift) acc.push("shift");
    if(meta) acc.push("meta");
    return '`${key}`' + ' [${which}, ${isChar?"char":"mod"}]' + (acc.length == 0 ? "" : ' (${acc.join(", ")})');
  }

  function get_coords() {
    return table.selection.map(range -> range.active);
  }
}

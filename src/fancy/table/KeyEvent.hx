package fancy.table;

import haxe.ds.Option;
using thx.Arrays;
using thx.Options;
import dots.Keys;

class KeyEvent {
  public static function fromKeyboardEvent(table: Table, e: js.html.KeyboardEvent) {
    var keyWithModifiers = Keys.getKeyAndModifiers(e);
    return new KeyEvent(
      table,
      keyWithModifiers,
      e.stopPropagation, e.preventDefault,
      () -> e.defaultPrevented
    );
  }

  public var table(default, null): Table;
  public var key(default, null): KeyWithModifiers;
  public var stopPropagation(default, null): Void -> Void;
  public var preventDefault(default, null): Void -> Void;
  public var defaultPrevented(default, null): Void -> Bool;
  public var coords(get, never): Option<Coords>;

  function new(table: Table, key: KeyWithModifiers, stopPropagation: Void -> Void, preventDefault: Void -> Void, defaultPrevented: Void -> Bool) {
    this.table = table;
    this.key = key;
    this.stopPropagation = stopPropagation;
    this.preventDefault = preventDefault;
    this.defaultPrevented = defaultPrevented;
  }

  public static var isMac(default, null): Bool = js.Browser.navigator.platform.toUpperCase().indexOf('MAC')>=0;

  public function isCmdOnMacOrCtrl() {
    var meta = key.modifiers.any(m -> switch m {
      case MetaOrOS(_): true;
      case _: false;
    });

    var ctrl = key.modifiers.any(m -> switch m {
      case Control: true;
      case _: false;
    });

    if(!ctrl && !meta) return false;
    return (isMac && meta) || (!isMac && ctrl);
  }

  function get_coords() {
    return table.selection.map(range -> range.active);
  }
}

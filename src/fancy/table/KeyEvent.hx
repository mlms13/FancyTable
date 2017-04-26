package fancy.table;

class KeyEvent {
  public static function fromKeyboardEvent(e: js.html.KeyboardEvent) {
    return new KeyEvent(e.key, e.shiftKey);
  }

  public var key(default, null): String;
  public var shift(default, null): Bool;

  public function new(key: String, shift: Bool) {
    this.key = key;
    this.shift = shift;
  }

  public function toString() {
    var acc = [];
    if(shift) acc.push("shift");
    return '`${key}`' + (acc.length == 0 ? "" : ' (${acc.join(", ")})');
  }
}

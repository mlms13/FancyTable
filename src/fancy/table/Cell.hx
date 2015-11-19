package fancy.table;

using fancy.browser.Dom;
import js.html.Element;
import js.html.Event;

class Cell {
  public var el(default, null) : Element;
  public var value(default, set) : String;
  public var fixed(default, set) : Bool;
  // TODO: consider making this an eventemitter instead
  public var onclick(default, set) : Event -> Void;

  public function new(?value : String, ?fixed = false, ?onclick : Event -> Void) {
    this.el = Dom.create("div.ft-cell", value);
    this.onclick = onclick != null ? onclick : function (_){};
    this.value = value;
    this.fixed = fixed;
  }

  function set_fixed(value : Bool) : Bool {
    if (value)
      el.addClass("ft-col-fixed");
    else
      el.removeClass("ft-col-fixed");

    return this.fixed = value;
  }

  function set_value(value : String) {
    el.textContent = value;
    return this.value = value;
  }

  function set_onclick(fn : Event -> Void) {
    el.off("click", onclick);
    el.on("click", fn);
    return this.onclick = fn;
  }

  public function copy() {
    return new Cell(value, fixed, onclick);
  }
}

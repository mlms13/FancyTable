package fancy.table;

using fancy.browser.Dom;
import js.html.Element;

class Cell {
  public var el(default, null) : Element;
  public var value(default, set) : String;
  public var fixed(default, set) : Bool;

  public function new(?value : String, ?fixed = false) {
    this.el = Dom.create("div.ft-cell", value);
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

  public function copy() {
    return new Cell(value, fixed);
  }
}

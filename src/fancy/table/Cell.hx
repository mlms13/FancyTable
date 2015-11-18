package fancy.table;

using fancy.browser.Dom;
import js.html.Element;

class Cell {
  public var el(default, null) : Element;
  public var value(default, null) : String; // TODO: just use the setter here
  public var fixed(default, set) : Bool;

  public function new(?value : String, ?fixed = false) {
    this.value = value;
    this.el = Dom.create("div.ft-cell", value);
    this.fixed = fixed;
  }

  function set_fixed(val : Bool) : Bool {
    if (val)
      el.addClass("ft-col-fixed");
    else
      el.removeClass("ft-col-fixed");

    return val;
  }

  public function setValue(value : String) {
    this.value = value;
    el.textContent = value;
  }

  public function copy() {
    return new Cell(value, fixed);
  }
}

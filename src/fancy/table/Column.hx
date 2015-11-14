package fancy.table;

using fancy.browser.Dom;
import js.html.Element;

class Column {
  public var el(default, null) : Element;
  public var value(default, null) : String;

  public function new(?value : String) {
    this.value = value;
    this.el = Dom.create("div.ft-col", value);
  }

  public function setValue(value : String) {
    this.value = value;
    el.empty().textContent = value;
  }
}

package fancy.table;

import fancy.browser.Dom;
import js.html.Element;

class Column {
  public var el(default, null) : Element;
  public function new(?value : String) {
    this.el = Dom.create("div.ft-col", value);
  }
}

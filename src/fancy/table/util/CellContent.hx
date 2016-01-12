package fancy.table.util;

import fancy.browser.Dom;
import js.html.Node;
using thx.Strings;

@:forward(cloneNode)
abstract CellContent(Node) from Node to Node {
  @:from
  public static inline function fromString(s : String) : CellContent {
    return Dom.create("span", s);
  }

  // @:to
  // public static inline function toString(el : Element) {
  //   return el.textContent;
  // }
}

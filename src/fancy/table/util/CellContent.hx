package fancy.table.util;

import fancy.browser.Dom;
import js.html.Element;
using thx.Strings;

abstract CellContent(Element) from Element to Element {
  @:from
  public static inline function fromString(s : String) : CellContent {
    return Dom.create("span", s);
  }

  // @:to
  // public static inline function toString(el : Element) {
  //   return el.textContent;
  // }
}

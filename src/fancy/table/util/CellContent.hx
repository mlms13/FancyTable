package fancy.table.util;

import dots.Dom;
import js.html.Node;
using thx.Strings;

@:forward(cloneNode)
abstract CellContent(Node) from Node to Node {
  @:from
  public static inline function fromString(s : String) : CellContent {
    return Dom.create("span", s);
  }

  @:from
  public static inline function fromInt(i : Int) : CellContent {
    return Std.string(i);
  }

  @:from
  public static inline function fromFloat(f : Float) : CellContent {
    return Std.string(f);
  }

  // @:to
  // public static inline function toString(el : Element) {
  //   return el.textContent;
  // }
}

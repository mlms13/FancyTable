package fancy.table.util;

import dots.Dom;
import js.html.Element;
using thx.Strings;

abstract CellContent(Element) from Element to Element {
  @:from
  public static inline function fromString(s : String) : CellContent
    return Dom.create("span", s);

  @:from
  public static inline function fromInt(i : Int) : CellContent
    return Std.string(i);

  @:from
  public static inline function fromFloat(f : Float) : CellContent
    return Std.string(f);

  public inline function clone() : CellContent
    return cast this.cloneNode(true);
}

package fancy.table.util;

import dots.Dom;
import js.html.Element;
using thx.Strings;

typedef CellContentImpl = Table -> Int -> Int -> Element;

abstract CellContent(CellContentImpl) from CellContentImpl to CellContentImpl {
  static inline function spanWithContent(s: String)
    return Dom.create("span", s);

  @:from
  public static function fromString(s: String): CellContent
    return function (_, _, _) {
      return spanWithContent(s);
    }

  @:from
  public static inline function fromInt(i: Int): CellContent
    return function (_, _, _) {
      return spanWithContent(Std.string(i));
    }

  @:from
  public static inline function fromFloat(f: Float): CellContent
    return function (_, _, _) {
      return spanWithContent(Std.string(f));
    }

  inline function toElement(t: Table, row: Int, col: Int) {
    return this(t, row, col);
  }

  public static function render(renderer: CellContent, t: Table, row: Int, col: Int): Element {
    return renderer.toElement(t, row, col);
  }
}

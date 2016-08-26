package fancy.table.util;

import dots.Dom;
import js.html.Element;
using thx.Strings;

typedef CellContentImpl = Row -> Element;

abstract CellContent(CellContentImpl) from CellContentImpl to CellContentImpl {
  static inline function spanWithContent(s: String)
    return Dom.create("span", s);

  @:from
  public static function fromString(s: String): CellContent
    return function (_) {
      return spanWithContent(s);
    }

  @:from
  public static inline function fromInt(i: Int): CellContent
    return function (_) {
      return spanWithContent(Std.string(i));
    }

  @:from
  public static inline function fromFloat(f: Float): CellContent
    return function (_) {
      return spanWithContent(Std.string(f));
    }

  inline function toElement(row) {
    return this(row);
  }

  public static function render(renderer: CellContent, row: Row): Element {
    return renderer.toElement(row);
  }
}

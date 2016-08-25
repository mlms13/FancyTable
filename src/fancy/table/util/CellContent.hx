package fancy.table.util;

import dots.Dom;
import js.html.Element;
using thx.Strings;

typedef CellContentImpl = Void -> Element;

abstract CellContent(CellContentImpl) from CellContentImpl to CellContentImpl {
  static inline function spanWithContent(s: String)
    return Dom.create("span", s);

  @:from
  public static function fromString(s: String): CellContent
    return function () {
      return spanWithContent(s);
    }

  @:from
  public static inline function fromInt(i: Int): CellContent
    return function () {
      return spanWithContent(Std.string(i));
    }

  @:from
  public static inline function fromFloat(f: Float): CellContent
    return spanWithContent.bind(Std.string(f));

  inline function toElement() {
    return this();
  }

  public static function render(renderer: CellContent): Element {
    return renderer.toElement();
  }
}

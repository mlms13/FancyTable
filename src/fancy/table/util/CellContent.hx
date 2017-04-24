package fancy.table.util;

import dots.Dom;
import js.html.Element;

typedef CellRenderer = Table -> Int -> Int -> Element;


// Possibly TODO: we could add a RenderedElement constructor here, and when we
// first render a LazyElement, replace it with the RenderedElement version.
// This way, we wouldn't have to actually create the dom more than once.
enum CellContentImpl {
  RawValue(v: String);
  LazyElement(fn: CellRenderer);
}

abstract CellContent(CellContentImpl) from CellContentImpl to CellContentImpl {
  static inline function spanWithContent(s: String)
    return Dom.create("span", s);

  @:from
  public static function fromString(s: String): CellContent
    return RawValue(s);

  @:from
  public static inline function fromInt(i: Int): CellContent
    return RawValue(Std.string(i));

  @:from
  public static inline function fromFloat(f: Float): CellContent
    return RawValue(Std.string(f));

  @:from
  public static inline function fromCellRenderer(fn: CellRenderer): CellContent
    return LazyElement(fn);

  public function render(className: String, t: Table, row: Int, col: Int): Element {
    return switch this {
      case RawValue(v): Dom.create("div", ["class" => className], v);
      case LazyElement(fn): fn(t, row, col);
    };
  }
}

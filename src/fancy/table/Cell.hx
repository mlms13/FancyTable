package fancy.table;

using dots.Dom;
import fancy.table.util.CellContent;
import js.html.Element;
import js.html.Node;
import js.html.Event;

class Cell {
  public var el(default, null) : Element;
  public var value(default, set) : CellContent;
  public var fixed(default, set) : Bool;
  // TODO: consider making this an eventemitter instead
  public var onclick(default, set) : Event -> Void;

  public function new(?value : CellContent, ?fixed = false, ?onclick : Event -> Void) {
    this.el = Dom.create("div.ft-cell");
    this.onclick = onclick != null ? onclick : function (_){};
    this.value = value != null ? value : "";
    this.fixed = fixed;
  }

  function set_fixed(value : Bool) : Bool {
    if (value)
      el.addClass("ft-col-fixed");
    else
      el.removeClass("ft-col-fixed");

    return this.fixed = value;
  }

  function set_value(value : CellContent) {
    // FIXME: should try to inject new text content without wiping out the cell,
    // which might contain a custom template.
    el.empty().append(value);
    return this.value = value;
  }

  function set_onclick(fn : Event -> Void) {
    el.off("click", onclick);
    el.on("click", fn);
    return this.onclick = fn;
  }

  /**
    Returns a new cell with all the same settings and content. If the optional
    `returnOriginalElement` flag is `true` (default), the returned cell will have
    the original value element (including all bound event handlers). If the flag
    is `false`, the returned cell will have a copy of value element, without
    event handlers.

    If you plan to place the returned copy above the original (on the z-axis),
    stick to the default `true`, so that the cell on top is the first to receive
    mouse events.
  **/
  public function copy(returnOriginalElement = true) {
    var cloned = value.cloneNode(true),
        instance = new Cell(returnOriginalElement ? value : cloned, fixed, onclick);

    if (returnOriginalElement) {
      this.value = cloned;
    }

    return instance;
  }
}

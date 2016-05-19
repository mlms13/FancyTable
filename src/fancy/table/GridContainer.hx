package fancy.table;

import js.html.Element;
using dots.Dom;

class GridContainer {
  public var topLeft(default, null) : Element;
  public var top(default, null) : Element;
  public var left(default, null) : Element;
  public var content(default, null) : Element;
  public var el(default, null) : Element;

  public function new() {
    topLeft = Dom.create("div.ft-table-fixed-top-left");
    top = Dom.create("div.ft-table-fixed-top");
    left = Dom.create("div.ft-table-fixed-left");
    content = Dom.create("div.ft-table-content");
    el = Dom.create("div.ft-table-grid-container")
      .append(topLeft)
      .append(top)
      .append(left)
      .append(content);
  }

  public function positionPanes(deltaTop : Int, deltaLeft : Int) {
    topLeft.style.top = '${deltaTop}px';
    topLeft.style.left = '${deltaLeft}px';
    top.style.top = '${deltaTop}px';
    left.style.left = '${deltaLeft}px';
  }

  public function empty() {
    topLeft.empty();
    top.empty();
    left.empty();
    content.empty();
  }
}

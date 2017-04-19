package fancy.table;

using thx.Nulls;

import fancy.table.util.CellContent;
import fancy.table.util.FancyTableClassOptions;
import fancy.table.util.FancyTableOptions;

import fancy.Grid;

typedef FancyTableClasses = {
  cellContent: String,
  rowExpanded: String,
  rowCollapsed: String,
  rowFoldHeader: String,
  rowIndent: String
}

class FancyTableSettings {
  public var fixedTop(default, null): Int;
  public var fixedLeft(default, null): Int;
  public var fallbackCell(default, null): CellContent;
  public var classes(default, null): FancyTableClasses;
  public var hSize(default, null): Int -> Int -> CellDimension;
  public var initialScrollX(default, null): HorizontalScrollPosition;
  public var initialScrollY(default, null): VerticalScrollPosition;
  public var onScroll(default, null) : Float -> Float -> Float -> Float -> Void;
  public var onResize(default, null) : Float -> Float -> Float -> Float -> Void;

  function new(fixedTop, fixedLeft, fallbackCell, classes, hSize, initialX, initialY, onScroll, onResize) {
    this.fixedTop = fixedTop;
    this.fixedLeft = fixedLeft;
    this.fallbackCell = fallbackCell;
    this.classes = classes;
    this.hSize = hSize;
    this.initialScrollX = initialX;
    this.initialScrollY = initialY;
    this.onScroll = onScroll;
    this.onResize = onResize;
  }

  static function classesFromOptions(?opts: FancyTableClassOptions): FancyTableClasses {
    if (opts == null) opts = {};

    return {
      cellContent: opts.cellContent != null ? opts.cellContent : "ft-cell-content",
      rowExpanded: opts.rowExpanded != null ? opts.rowExpanded : "ft-row-expanded",
      rowCollapsed: opts.rowCollapsed != null ? opts.rowCollapsed : "ft-row-collapsed",
      rowFoldHeader: opts.rowFoldHeader != null ? opts.rowFoldHeader : "ft-row-fold-header",
      rowIndent: opts.rowIndent != null ? opts.rowIndent : "ft-row-indent-"
    };
  }

  public static function fromOptions(?opts: FancyTableOptions) {
    if (opts == null) opts = {};

    return new FancyTableSettings(
      opts.fixedTop.or(0),
      opts.fixedLeft.or(0),
      opts.fallbackCell.or(CellContent.fromString("")),
      classesFromOptions(opts.classes),
      opts.hSize.or(function (_, _) return RenderSmart),
      opts.initialScrollX.or(Left),
      opts.initialScrollY.or(Top),
      opts.onScroll.or(function(_, _, _, _) {}),
      opts.onResize.or(function(_, _, _, _) {})
    );
  }
}

package fancy.table;

using thx.Nulls;

import fancy.table.util.CellContent;
import fancy.table.util.FancyTableClassOptions;
import fancy.table.util.FancyTableOptions;

import fancy.Grid;

typedef FancyTableClasses = {
  rowExpanded: String,
  rowCollapsed: String,
  rowFoldHeader: String,
  rowIndent: String,

  cellContent: String,
  cellActive: String,
  cellSelected: String,
  cellSelectedTop: String,
  cellSelectedRight: String,
  cellSelectedBottom: String,
  cellSelectedLeft: String
}

class FancyTableSettings {
  public var fixedTop(default, null): Int;
  public var fixedLeft(default, null): Int;
  public var fallbackCell(default, null): CellContent;
  public var classes(default, null): FancyTableClasses;
  public var hSize(default, null): Int -> Int -> CellDimension;
  public var initialScrollX(default, null): HorizontalScrollPosition;
  public var initialScrollY(default, null): VerticalScrollPosition;

  public var onScroll(default, null) : ScrollEvent -> Void;
  public var onResize(default, null) : ResizeEvent -> Void;
  public var onFocus(default, null) : Table -> Void;
  public var onBlur(default, null) : Table -> Void;
  public var onKey(default, null): KeyEvent -> Void;
  public var onClick(default, null): CellEvent -> Void;
  public var onDoubleClick(default, null): CellEvent -> Void;
  public var onRangeChange(default, null): RangeEvent -> Void;

  public var selectionEnabled(default, null): Bool;
  public var rangeSelectionEnabled(default, null): Bool;
  public var focusOnHover(default, null): Bool;
  public var alwaysFocused(default, null): Bool;

  function new(fixedTop, fixedLeft, fallbackCell, classes, hSize, initialX, initialY, selectionEnabled, rangeSelectionEnabled, focusOnHover, alwaysFocused, onScroll, onResize, onFocus, onBlur, onKey, onClick, onDoubleClick, onRangeChange) {
    this.fixedTop = fixedTop;
    this.fixedLeft = fixedLeft;
    this.fallbackCell = fallbackCell;
    this.classes = classes;
    this.hSize = hSize;
    this.initialScrollX = initialX;
    this.initialScrollY = initialY;

    this.selectionEnabled = selectionEnabled;
    this.rangeSelectionEnabled = rangeSelectionEnabled;

    this.focusOnHover = focusOnHover;
    this.alwaysFocused = alwaysFocused;

    this.onScroll = onScroll;
    this.onResize = onResize;
    this.onFocus = onFocus;
    this.onBlur = onBlur;
    this.onKey = onKey;
    this.onDoubleClick = onDoubleClick;
    this.onClick = onClick;
    this.onRangeChange = onRangeChange;
  }

  static function classesFromOptions(?opts: FancyTableClassOptions): FancyTableClasses {
    if (opts == null) opts = {};

    return {
      cellContent: opts.cellContent != null ? opts.cellContent : "ft-cell-content",
      rowExpanded: opts.rowExpanded != null ? opts.rowExpanded : "ft-row-expanded",
      rowCollapsed: opts.rowCollapsed != null ? opts.rowCollapsed : "ft-row-collapsed",
      rowFoldHeader: opts.rowFoldHeader != null ? opts.rowFoldHeader : "ft-row-fold-header",
      rowIndent: opts.rowIndent != null ? opts.rowIndent : "ft-row-indent-",
      cellActive: opts.cellActive != null ? opts.cellActive : "ft-cell-active",
      cellSelected: opts.cellSelected != null ? opts.cellSelected : "ft-cell-selected",
      cellSelectedTop: opts.cellSelectedTop != null ? opts.cellSelectedTop : "ft-cell-selected-top",
      cellSelectedRight: opts.cellSelectedRight != null ? opts.cellSelectedRight : "ft-cell-selected-right",
      cellSelectedBottom: opts.cellSelectedBottom != null ? opts.cellSelectedBottom : "ft-cell-selected-bottom",
      cellSelectedLeft: opts.cellSelectedLeft != null ? opts.cellSelectedLeft : "ft-cell-selected-left"
    };
  }

  public static function fromOptions(?opts: FancyTableOptions) {
    if (opts == null) opts = {};

    var fixedTop = opts.fixedTop.or(0),
        fixedLeft = opts.fixedLeft.or(0);
    return new FancyTableSettings(
      fixedTop,
      fixedLeft,
      opts.fallbackCell.or(CellContent.fromString("")),
      classesFromOptions(opts.classes),
      opts.hSize.or(function (_, _) return RenderSmart),
      opts.initialScrollX.or(Left),
      opts.initialScrollY.or(Top),
      opts.selectionEnabled.or(true),
      opts.rangeSelectionEnabled.or(true),
      opts.focusOnHover.or(true),
      opts.alwaysFocused.or(false),
      opts.onScroll.or(function(_) {}),
      opts.onResize.or(function(_) {}),
      opts.onFocus.or(function(_) {}),
      opts.onBlur.or(function(_) {}),
      opts.onKey.or(function(_) { }),
      opts.onClick.or(function(_) { }),
      opts.onDoubleClick.or(function(_) { }),
      opts.onRangeChange.or(function(_) { })
    );
  }
}

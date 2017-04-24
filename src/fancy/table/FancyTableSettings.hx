package fancy.table;

import haxe.ds.Option;
using thx.Functions;
using thx.Options;
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

  public var canSelect(default, null): Int -> Int -> Bool;
  public var selectionEnabled(default, null): Bool;
  public var rangeSelectionEnabled(default, null): Bool;
  public var selection(default, null): Option<Range>;

  function new(fixedTop, fixedLeft, fallbackCell, classes, hSize, initialX, initialY, onScroll, onResize, canSelect, selectionEnabled, rangeSelectionEnabled, selection) {
    this.fixedTop = fixedTop;
    this.fixedLeft = fixedLeft;
    this.fallbackCell = fallbackCell;
    this.classes = classes;
    this.hSize = hSize;
    this.initialScrollX = initialX;
    this.initialScrollY = initialY;
    this.onScroll = onScroll;
    this.onResize = onResize;

    this.canSelect = canSelect;
    this.selectionEnabled = selectionEnabled;
    this.rangeSelectionEnabled = rangeSelectionEnabled;
    this.selection = selection;
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
    // TODO !!! add classes for selections
  }

  public static function fromOptions(?opts: FancyTableOptions) {
    if (opts == null) opts = {};

/*
  ?canSelect: Int -> Int -> Bool,
  ?selectionEnabled: Bool,
  ?rangeSelectionEnabled: Bool,
  ?selection: Option<{ minRow: Int, minCol: Int, maxRow: Int, maxCol: Int}>
*/
    var fixedTop = opts.fixedTop.or(0),
        fixedLeft = opts.fixedLeft.or(0),
        selection = Options.ofValue(opts.selection).map.fn(new fancy.table.Range(new Coords(_.minRow, _.minCol), new Coords(_.maxRow, _.maxCol)));
    return new FancyTableSettings(
      fixedTop,
      fixedLeft,
      opts.fallbackCell.or(CellContent.fromString("")),
      classesFromOptions(opts.classes),
      opts.hSize.or(function (_, _) return RenderSmart),
      opts.initialScrollX.or(Left),
      opts.initialScrollY.or(Top),
      opts.onScroll.or(function(_, _, _, _) {}),
      opts.onResize.or(function(_, _, _, _) {}),
      opts.canSelect.or(function(r, c) return r >= fixedTop && c >= fixedLeft ), // TODO !!!,
      opts.selectionEnabled.or(true),
      opts.rangeSelectionEnabled.or(true),
      selection
    );
  }
}

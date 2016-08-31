package fancy.table;

import fancy.table.util.Types;
import fancy.table.util.CellContent;

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

  function new(fixedTop, fixedLeft, fallbackCell, classes) {
    this.fixedTop = fixedTop;
    this.fixedLeft = fixedLeft;
    this.fallbackCell = fallbackCell;
    this.classes = classes;
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
      opts.fixedTop != null ? opts.fixedTop : 0,
      opts.fixedLeft != null ? opts.fixedLeft : 0,
      opts.fallbackCell != null ? opts.fallbackCell : CellContent.fromString(""),
      classesFromOptions(opts.classes)
    );
  }
}

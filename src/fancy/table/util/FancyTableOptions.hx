package fancy.table.util;

import fancy.Grid;
import fancy.Table;
import fancy.table.KeyEvent;

typedef FancyTableOptions = {
  ?fixedTop: Int,
  ?fixedLeft: Int,
  ?fallbackCell: CellContent,
  ?classes: FancyTableClassOptions,
  ?hSize: Int -> Int -> CellDimension,
  ?initialScrollX: HorizontalScrollPosition,
  ?initialScrollY: VerticalScrollPosition,
  // TODO !!!
  ?canSelect: Int -> Int -> Bool,
  ?selectionEnabled: Bool,
  ?rangeSelectionEnabled: Bool,
  ?selection: { minRow: Int, minCol: Int, maxRow: Int, maxCol: Int },
  ?active: { row: Int, col: Int },
  ?focusOnHover: Bool,
  ?onScroll: Float -> Float -> Float -> Float -> Void,
  ?onResize: Float -> Float -> Float -> Float -> Void,
  ?onFocus: Void -> Void,
  ?onBlur: Void -> Void,
  ?onKey: KeyEvent -> Coords -> Table -> Void,
  ?onDoubleClick: Coords -> Table -> Void
};

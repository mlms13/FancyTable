package fancy.table.util;

import fancy.Grid;

typedef FancyTableOptions = {
  ?fixedTop: Int,
  ?fixedLeft: Int,
  ?fallbackCell: CellContent,
  ?classes: FancyTableClassOptions,
  ?hSize: Int -> Int -> CellDimension,
  ?initialScrollX: HorizontalScrollPosition,
  ?initialScrollY: VerticalScrollPosition,
  ?onScroll: Float -> Float -> Float -> Float -> Void,
  ?onResize: Float -> Float -> Float -> Float -> Void
};

package fancy.table;

import haxe.ds.Option;
using dots.Dom;
import fancy.table.FancyTableSettings;
import fancy.table.util.CellContent;
import js.html.Element;
using thx.Arrays;
using thx.Options;

class Row {
  public var cells(default, null): Array<CellContent>;
  public var rows(default, null): Array<Row> = [];
  public var expanded(default, null): Bool;
  public var height(default, null): fancy.Grid.CellDimension;
  var indentation: Int;
  public var classSettings(default, null): FancyTableClasses;
  var customClasses: Array<String>;
  var table: Table;

  public function new(table: Table, cells: Array<CellContent>, classSettings, height, ?customClasses, ?expanded = true, ?indentation = 0) {
    this.table = table;
    this.cells = cells;
    this.classSettings = classSettings;
    this.height = height;
    this.customClasses = customClasses != null ? customClasses : [];
    this.expanded = expanded;
    this.indentation = indentation;
  }

  // Converts various bits of row-related state into classes for the DOM. These
  // classes get applied to each cell that is considered part of this row.
  function getClasses(): Array<String> {
    var classes: Array<String> = [
      classSettings.rowIndent + Std.string(indentation)
    ].concat(customClasses);

    if (rows.length > 0) {
      classes.push(classSettings.rowFoldHeader);
      classes.push(expanded ? classSettings.rowExpanded : classSettings.rowCollapsed);
    }

    return classes;
  }

  public function renderCell(table: Table, row: Int, col: Int, classes: Array<String>): Option<Element> {
    return cells.getOption(col).map(function (cell) {
      return renderCellContainer(classes, cell.render(classSettings.cellContent, table, row, col), row, col);
    });
  }

  public function renderCellContainer(classes: Array<String>, content: Element, row: Int, col: Int) {
    var classes = (switch table.selection {
      case None: [];
      case Some(range):
        var buff = [];
        if(range.contains(row, col)) {
          if(range.isActive(row, col))
            buff.push(classSettings.cellActive);
          buff.push(classSettings.cellSelected);
          if(range.isOnTop(row))
            buff.push(classSettings.cellSelectedTop);
          if(range.isOnRight(col))
            buff.push(classSettings.cellSelectedRight);
          if(range.isOnBottom(row))
            buff.push(classSettings.cellSelectedBottom);
          if(range.isOnLeft(col))
            buff.push(classSettings.cellSelectedLeft);
        }
        buff;
    }).concat(classes);
    return Dom.create("div", ["class" => getClasses().concat(classes).join(" ")], [
      content
    ]);
  }

  public function addChildRow(child: Row) {
    rows = rows.append(child);
  }

  public inline function addChildRows(children: Array<Row>) {
    rows = rows.concat(children);
  }

  public function removeChildRow(child: Row) {
    rows.remove(child);
  }

  public function expand() {
    expanded = true;
  }

  public function collapse() {
    expanded = false;
  }

  public function toggle() {
    expanded = !expanded;
  }

  /**
    Sets the value of a cell given the 0-based index of the cell. Cells can have
    strings, numbers, or html elements as content.
  **/
  public function setCellValue(index: Int, value: CellContent): Row {
    if (index >= cells.length) {
      // TODO: throwing? find a better way
      return throw 'Cannot set "$value" for cell at index $index, which does not exist';
    }

    cells[index] = value;
    return this;
  }
}

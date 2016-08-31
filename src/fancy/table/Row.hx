package fancy.table;

import haxe.ds.Option;
using dots.Dom;
import fancy.table.FancyTableSettings;
import fancy.table.util.Types;
import fancy.table.util.CellContent;
import js.html.Element;
using thx.Arrays;
using thx.Functions;
using thx.Ints;
using thx.Objects;
using thx.Options;

class Row {
  public var cells(default, null): Array<CellContent>;
  public var rows(default, null): Array<Row> = [];
  public var expanded(default, null): Bool;
  var indentation: Int;
  var classSettings: FancyTableClasses;
  var customClasses: Array<String>;

  public function new(cells: Array<CellContent>, classSettings, ?customClasses, ?expanded = true, ?indentation = 0) {
    this.cells = cells;
    this.classSettings = classSettings;
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

  public function renderCell(table: Table, row: Int, col: Int): Option<Element> {
    return cells.getOption(col).map(function (cell) {
      return Dom.create("div", ["class" => getClasses().join(" ")], [
        cell.render(classSettings.cellContent, table, row, col)
      ]);
    });
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

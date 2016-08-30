package fancy.table;

import haxe.ds.Option;
using dots.Dom;
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
  public var settings(default, null): FancyRowOptions;

  public function new(cells: Array<CellContent>, ?options: FancyRowOptions) {
    this.cells = cells;
    settings = createDefaultOptions(options);
    settings.classes = createDefaultClasses(settings.classes);
  }

  function createDefaultOptions(?options : FancyRowOptions) {
    return Objects.merge({
      classes : {},
      expanded : true,
      indentation : 0
    }, options == null ? ({} : FancyRowOptions) : options);
  }

  function createDefaultClasses(?classes : FancyRowClasses) : FancyRowClasses {
    return Objects.merge({
      row : "ft-row",
      expanded : "ft-row-expanded",
      collapsed : "ft-row-collapsed",
      foldHeader : "ft-row-fold-header",
      indent : "ft-row-indent-",
      custom : ([] : Array<String>)
    }, classes == null ? {} : classes);
  }

  public function renderCell(table: Table, row: Int, col: Int): Option<Element> {
    return cells.getOption(col).map(function (cell) {
      var classes: Array<String> = [
        settings.classes.indent + Std.string(settings.indentation)
      ].concat(settings.classes.custom);

      if (rows.length > 0) {
        classes.push(settings.classes.foldHeader);
        classes.push(settings.expanded ? settings.classes.expanded : settings.classes.collapsed);
      }

      return Dom.create("div", ["class" => classes.join(" ")], [
        // TODO: read this class from the settings or something
        CellContent.render(cell, "ft-cell-content", table, row, col)
      ]);
    });
  }

  public function setCustomClasses(classes: Array<String>) {
    settings.classes.custom = classes;
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
    settings.expanded = true;
  }

  public function collapse() {
    settings.expanded = false;
  }

  public function toggle() {
    settings.expanded = !settings.expanded;
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

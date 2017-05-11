using dots.Dom;

import haxe.ds.Option;

import js.html.Element;

using thx.Arrays;
using thx.Maps;
using thx.Options;
import thx.Tuple;

import fancy.Table;
import fancy.table.util.CellContent;
import fancy.table.util.RowData;
import fancy.table.CellEvent;
import fancy.table.Coords;
import fancy.table.KeyEvent;

typedef Card = {
  name : String,
  color : String,
  type : String,
  rarity : String,
  multiverseId : String,
  cmc : Int,
  draftval : Float,
  tcgprice : Float
};

enum NestedDataRowType {
  HeaderRow(cells : Array<DataCell>);
  GroupRow(cell : DataCell);
  CardRow(cells : Array<DataCell>);
}

typedef NestedDataRow = {
  type: NestedDataRowType,
  isExpanded: Bool,
  childRows: Array<NestedDataRow>
};

typedef FlatDataRow = {
  cells: Array<DataCell>
}

enum DataCell {
  CTextFold(text : String, onToggle: Void -> Void);
  CText(text : String);
  CInt(num : Int);
  CFloat(num : Float);
  CLink(label : String, href: String);
}

class Main {
  static var nestedDataRows(default, null) : Array<NestedDataRow>;
  static var flatDataRows(default, null) : Array<FlatDataRow>;

  static function main() {
    var cards = getCards();

    nestedDataRows = createNestedDataRows(cards);
    flatDataRows = createFlatDataRows(cards);

    var elNested = js.Browser.document.querySelector(".table-container-nested");
    new Table(elNested, Nested(nestedDataRows.map(nestedDataRowToRowData)), {
      fixedTop: 1,
      fixedLeft: 1,
      focusOnHover: false,
      rangeSelectionEnabled: false
    });

    var elFlat = js.Browser.document.querySelector(".table-container-flat");
    var table = new Table(elFlat, Tabular(flatDataRows.map(flatDataRowToCellContents)), {
      fixedTop: 1,
      fixedLeft: 1,
      selection: {
        minRow: 1,
        minCol: 1,
        maxRow: 2,
        maxCol: 3
      },
      onKey: function(e: KeyEvent) {
        e.coords.each(coords -> onStartEditingFlatRowCell(coords, e.key, e.table));
      },
      onDoubleClick: function(event: CellEvent) {
        onStartEditingFlatRowCell(event.coords, "", event.table);
      },
      focusOnHover: false,
      alwaysFocused: true
    });
  }

  /////////////////////////////////////////////////////////////////////////////
  // Nested table stuff
  /////////////////////////////////////////////////////////////////////////////

  static function createNestedDataRows(cards : Array<Card>) : Array<NestedDataRow> {
    var headerRow : NestedDataRow =  {
      type: HeaderRow([CText("Cards"), CText("CMC"), CText("Draft value"), CText("Price")]),
      isExpanded: true,
      childRows: []
    };
    var bodyRows : Array<NestedDataRow> = createNestedDataRowsUsingGroupBys(cards, [
      function (card) return card.color,
      function (card) return card.rarity,
      function (card) return card.type,
      function (card) return card.name
    ]);
    return [headerRow].concat(bodyRows);
  }

  static function createNestedDataRowsUsingGroupBys(cards : Array<Card>, groupBys : Array<Card -> String>) : Array<NestedDataRow> {
    return cards.groupByAppend(groupBys[0], new Map())
      .tuples()
      .map(function(tuple : Tuple<String, Array<Card>>) : NestedDataRow {
        var groupKey = tuple.left;
        var groupCards = tuple.right;
        var restOfGroupBys = groupBys.rest();

        //trace(groupKey);
        return if (restOfGroupBys.length == 0) {
          // This is a little weird because groupCards could have multiple cards, but since there is no more grouping to do
          // and our last grouping was by "name" (which should be unique) we have to assume that we're just interested in one card here
          var card = groupCards[0];
          {
            type: CardRow([
              CLink(card.name, 'http://gatherer.wizards.com/Pages/Card/Details.aspx?multiverseid=${card.multiverseId}'),
              CInt(card.cmc),
              CFloat(card.draftval),
              CFloat(card.tcgprice)
            ]),
            isExpanded: true,
            childRows: []
          };
        } else {
          var row : NestedDataRow;
          row = {
            type: GroupRow(CTextFold(groupKey, () -> row.isExpanded = !row.isExpanded)),
            isExpanded: true,
            childRows: createNestedDataRowsUsingGroupBys(groupCards, restOfGroupBys)
          };
          row;
        }
      });
  }

  static function nestedDataRowToRowData(nestedDataRow : NestedDataRow) : RowData {
    var cells = switch nestedDataRow.type {
      case HeaderRow(cells) : cells;
      case GroupRow(cell) : [cell];
      case CardRow(cells) : cells;
    };
    return {
      // Don't bind the cell values to the render function here - we want the render function
      // to do a lookup in our NestedDataRow data structure.
      values: cells.map(_ -> CellContent.fromCellRenderer(renderNestedRowDataCell)),
      data: nestedDataRow.childRows.map(nestedDataRowToRowData),
      meta: {
        expanded: nestedDataRow.isExpanded
      }
    };
  }

  static function flattenNestedDataRows(nestedDataRows : Array<NestedDataRow>) : Array<NestedDataRow> {
    return nestedDataRows.reduce(function(acc : Array<NestedDataRow>, row : NestedDataRow) : Array<NestedDataRow> {
      acc.push(row);
      if (row.isExpanded) {
        acc = acc.concat(flattenNestedDataRows(row.childRows));
      }
      return acc;
    }, []);
  }

  static function getNestedRowCellByCoords(row : Int, col: Int) : Option<{ row: NestedDataRow, cell: DataCell }> {
    // row is an absolute row index, but to get the desired row in our nested structure, we have
    // to recursively traverse the tree to find the right row.
    // !!! TODO !!!
    // flattening the nested rows for each lookup is slow... there
    // should be a faster way to get the nested row by index
    var flattenedNestedDataRows = flattenNestedDataRows(nestedDataRows);
    return flattenedNestedDataRows.getOption(row)
      .flatMap(function(row : NestedDataRow) : Option<{ row: NestedDataRow, cell: DataCell }> {
        return (switch row.type {
          case HeaderRow(cells) : cells;
          case GroupRow(cell) : [cell];
          case CardRow(cells) : cells;
        })
        .getOption(col)
        .map(cell -> { row: row, cell: cell });
      });
  }

  static function renderNestedRowDataCell(table : Table, row : Int, col : Int) : Element {
    return getNestedRowCellByCoords(row, col)
      .cataf(
        () -> renderUnknownCell(row, col),
        data -> renderDataCell({ row: row, col: col, cell: data.cell, table: table })
      );
  }

  /////////////////////////////////////////////////////////////////////////////
  // Flat table stuff
  /////////////////////////////////////////////////////////////////////////////

  static function createFlatDataRows(cards : Array<Card>) : Array<FlatDataRow> {
    var headerRow : FlatDataRow = {
      cells: [
        CText("Cards"),
        CText("CMC"),
        CText("Color"),
        CText("Type"),
        CText("Rarity"),
        CText("Draft value"),
        CText("Price")
      ]
    };
    var bodyRows : Array<FlatDataRow> = cards.map(function(card : Card) : FlatDataRow {
      return {
        cells: [
          CLink(card.name, 'http://gatherer.wizards.com/Pages/Card/Details.aspx?multiverseid=${card.multiverseId}'),
          CInt(card.cmc),
          CText(card.color),
          CText(card.type),
          CText(card.rarity),
          CFloat(card.draftval),
          CFloat(card.tcgprice)
        ]
      };
    });
    return [headerRow].concat(bodyRows);
  }

  static function flatDataRowToCellContents(flatDataRow : FlatDataRow) : Array<CellContent> {
    // Don't bind the cell value to the render here - we want to use a lookup function to
    // dynamically render the cell from the current data structure state.
    return flatDataRow.cells.map(_ -> CellContent.fromCellRenderer(renderFlatRowDataCell));
  }

  static function renderFlatRowDataCell(table : Table, row : Int, col : Int) : Element {
    return getFlatRowCellByCoords(row, col)
      .cataf(
        () -> renderUnknownCell(row, col),
        rowCell -> renderDataCell({ row: row, col: col, cell: rowCell.cell, table: table })
      );
  }

  static function getFlatRowCellByCoords(row : Int, col: Int) : Option<{ row: FlatDataRow, cell: DataCell }> {
    // Our flat structure matches the view structure, so we can do a direct lookup by row/col
    return flatDataRows.getOption(row)
      .flatMap(function(row : FlatDataRow) : Option<{ row: FlatDataRow, cell: DataCell }> {
        return row.cells
          .getOption(col)
          .map(cell -> { row: row, cell: cell });
      });
  }

  static function setFlatRowCellByCoords(row : Int, col: Int, cell : DataCell) : Void {
    flatDataRows.getOption(row)
      .each(row -> row.cells[col] = cell);
  }

  /////////////////////////////////////////////////////////////////////////////
  // Other stuff
  /////////////////////////////////////////////////////////////////////////////

  static function renderUnknownCell(row : Int, col : Int) : Element {
    return Dom.create('div', 'cell not found: $row $col');
  }

  static function renderDataCell(options: { row : Int, col: Int, cell : DataCell, table: Table }) : Element {
    var children = switch options.cell {
      case CTextFold(text, _) | CText(text) : [
        Dom.create('span', text)
      ];
      case CInt(num) : [
        Dom.create('span', Std.string(num))
      ];
      case CFloat(num) : [
        Dom.create('span', Std.string(num))
      ];
      case CLink(label, href) : [
        Dom.create("span", label),
        Dom.create("a", [
          "href" => href,
          "target" => "_blank"
        ], [
          Dom.create("i.fa.fa-external-link-square")
        ])
      ];
    }
    var element = Dom.create("div.ft-cell-content", children);
    // If this is a fold cell - add the click handler to update our state, and toggle the row via the fancy table API
    switch options.cell {
      case CTextFold(_, onToggle) :
        element.addEventListener("click", function(e : js.html.Event) {
          onToggle(); // this has to be done before table.toggleRow, because we need to update
                      // our internal "isExpanded" state before the cells are re-rendered
          options.table.toggleRow(options.row);
        });
      case _ : // no-op: cell has no click handler
    };
    return element;
  }

  static function onStartEditingFlatRowCell(coords: Coords, typed: String, table: Table) {
    var value : String = getFlatRowCellByCoords(coords.row, coords.col)
      .map(data -> switch data.cell {
        case CTextFold(text, _) : text;
        case CText(text) : text;
        case CInt(n) : Std.string(n);
        case CFloat(n) : Std.string(n);
        case CLink(text, href) : text;
      })
      .getOrElse("");

    var input = js.Browser.document.createInputElement();
    input.value = "";
    switch typed {
      case other if(other.length == 1): // normal char
        input.value = typed;
      case _:
        return;
    }
    thx.Timer.delay(input.focus, 10); // needed because the element is still not attached to the DOM
    input.onkeydown = function(e: js.html.KeyboardEvent) {
      e.stopPropagation();
    }
    input.onkeyup = function(e: js.html.KeyboardEvent) {
      e.stopPropagation();
      setFlatRowCellByCoords(coords.row, coords.col, CText(input.value));
      if(e.key == "Enter")
        table.renderCell(coords.row, coords.col, renderFlatRowDataCell);
    }
    input.onblur = function(e: js.html.MouseEvent) {
      e.stopPropagation();
      setFlatRowCellByCoords(coords.row, coords.col, CText(input.value));
      table.renderCell(coords.row, coords.col, renderFlatRowDataCell);
    }

    table.renderCell(coords.row, coords.col, CellContent.fromElement(input));
  }

  static function getCards() : Array<Card> {
    // There are intentional duplicates here just to get a greater number of cards.
    // The dupes are filtered out for the "nested" view, but show up in the flattened view.
    return [
      { name : "Quarantine Field", color : "White", type : "Enchantment", rarity : "Mythic", multiverseId : "402001", cmc : 2, draftval : 5, tcgprice : 2.52 },
      { name : "Hero of Goma Fada", color : "White", type : "Creature", rarity : "Rare", multiverseId : "401913", cmc : 5, draftval : 3.5, tcgprice : 0.25 },
      { name : "Felidar Sovereign", color : "White", type : "Creature", rarity : "Rare", multiverseId : "401878", cmc : 6, draftval : 4, tcgprice : 0.56 },
      { name : "Part the Waterveil", color : "Blue", type : "Sorcery", rarity : "Mythic", multiverseId : "401982", cmc : 6, draftval : 2.0, tcgprice : 1.29 },
      { name : "Guardian of Tazeem", color : "Blue", type : "Creature", rarity : "Rare", multiverseId : "401906", cmc : 5, draftval : 4.5, tcgprice : 0.25 },

      { name : "Quarantine Field", color : "White", type : "Enchantment", rarity : "Mythic", multiverseId : "402001", cmc : 2, draftval : 5, tcgprice : 2.52 },
      { name : "Hero of Goma Fada", color : "White", type : "Creature", rarity : "Rare", multiverseId : "401913", cmc : 5, draftval : 3.5, tcgprice : 0.25 },
      { name : "Felidar Sovereign", color : "White", type : "Creature", rarity : "Rare", multiverseId : "401878", cmc : 6, draftval : 4, tcgprice : 0.56 },
      { name : "Part the Waterveil", color : "Blue", type : "Sorcery", rarity : "Mythic", multiverseId : "401982", cmc : 6, draftval : 2.0, tcgprice : 1.29 },
      { name : "Guardian of Tazeem", color : "Blue", type : "Creature", rarity : "Rare", multiverseId : "401906", cmc : 5, draftval : 4.5, tcgprice : 0.25 },

      { name : "Quarantine Field", color : "White", type : "Enchantment", rarity : "Mythic", multiverseId : "402001", cmc : 2, draftval : 5, tcgprice : 2.52 },
      { name : "Hero of Goma Fada", color : "White", type : "Creature", rarity : "Rare", multiverseId : "401913", cmc : 5, draftval : 3.5, tcgprice : 0.25 },
      { name : "Felidar Sovereign", color : "White", type : "Creature", rarity : "Rare", multiverseId : "401878", cmc : 6, draftval : 4, tcgprice : 0.56 },
      { name : "Part the Waterveil", color : "Blue", type : "Sorcery", rarity : "Mythic", multiverseId : "401982", cmc : 6, draftval : 2.0, tcgprice : 1.29 },
      { name : "Guardian of Tazeem", color : "Blue", type : "Creature", rarity : "Rare", multiverseId : "401906", cmc : 5, draftval : 4.5, tcgprice : 0.25 },

      { name : "Quarantine Field", color : "White", type : "Enchantment", rarity : "Mythic", multiverseId : "402001", cmc : 2, draftval : 5, tcgprice : 2.52 },
      { name : "Hero of Goma Fada", color : "White", type : "Creature", rarity : "Rare", multiverseId : "401913", cmc : 5, draftval : 3.5, tcgprice : 0.25 },
      { name : "Felidar Sovereign", color : "White", type : "Creature", rarity : "Rare", multiverseId : "401878", cmc : 6, draftval : 4, tcgprice : 0.56 },
      { name : "Part the Waterveil", color : "Blue", type : "Sorcery", rarity : "Mythic", multiverseId : "401982", cmc : 6, draftval : 2.0, tcgprice : 1.29 },
      { name : "Guardian of Tazeem", color : "Blue", type : "Creature", rarity : "Rare", multiverseId : "401906", cmc : 5, draftval : 4.5, tcgprice : 0.25 }
    ];
  }
}

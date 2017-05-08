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

enum NestedDataRow {
  HeaderRow(cells : Array<DataCell>);
  GroupRow(cell : DataCell, childRows : Array<NestedDataRow>);
  CardRow(cells : Array<DataCell>);
}

typedef FlatDataRow = {
  cells: Array<DataCell>
}

enum DataCell {
  CTextFold(text : String);
  CText(text : String);
  CInt(num : Int);
  CFloat(num : Float);
  CLink(label : String, href: String);
}

class Main {
  // these are our state/lookup tables for rendering cells by coordinates
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
    new Table(elFlat, Tabular(flatDataRows.map(flatDataRowToCellContents)), {
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
      }
    });
  }

  /////////////////////////////////////////////////////////////////////////////
  // Nested table stuff
  /////////////////////////////////////////////////////////////////////////////

  static function createNestedDataRows(cards : Array<Card>) : Array<NestedDataRow> {
    var headerRow : NestedDataRow =  HeaderRow([CText("Cards"), CText("CMC"), CText("Draft value"), CText("Price")]);
    var bodyRows : Array<NestedDataRow> = createNestedDataRowsWithGroupBys(cards, [
      function (card) return card.color,
      function (card) return card.rarity,
      function (card) return card.type,
      function (card) return card.name
    ]);
    return [headerRow].concat(bodyRows);
  }

  static function createNestedDataRowsWithGroupBys(cards : Array<Card>, groupBys : Array<Card -> String>) : Array<NestedDataRow> {
    return cards.groupByAppend(groupBys[0], new Map())
      .tuples()
      .map(function(tuple : Tuple<String, Array<Card>>) : NestedDataRow {
        var groupKey = tuple.left;
        var groupCards = tuple.right;
        var restOfGroupBys = groupBys.rest();

        trace(groupKey);

        return if (restOfGroupBys.length == 0) {
          //if (groupCards.length != 0) {
            //throw new thx.Error('group cards should have been reduced to a single card at this point');
          //}
          var card = groupCards[0];
          // No more group bys to handle - we are at the card level
          // Nested card row
          CardRow([
            CLink(card.name, 'http://gatherer.wizards.com/Pages/Card/Details.aspx?multiverseid=${card.multiverseId}'),
            CInt(card.cmc),
            CFloat(card.draftval),
            CFloat(card.tcgprice)
          ]);
        } else {
          // nested group row
          GroupRow(CText(groupKey), createNestedDataRowsWithGroupBys(groupCards, restOfGroupBys));
        }
      });
  }

  static function nestedDataRowToRowData(nestedDataRow : NestedDataRow) : RowData {
    // Don't bind the cells to the renderer functions here - we want to use a lookup function, so we
    // can change the underlying data and re-render different things
    return switch nestedDataRow {
      case HeaderRow(cells) : {
        values: cells.map(_ -> CellContent.fromCellRenderer(renderNestedRowDataCell))
      };
      case GroupRow(cell, childRows) : {
        values: [cell].map(_ -> CellContent.fromCellRenderer(renderNestedRowDataCell)),
        data: childRows.map(nestedDataRowToRowData)
      };
      case CardRow(cells) : {
        values: cells.map(_ -> CellContent.fromCellRenderer(renderNestedRowDataCell))
      };
    };
  }

  static function flattenNestedDataRows(nestedDataRows : Array<NestedDataRow>) : Array<NestedDataRow> {
    return nestedDataRows.reduce(function(acc : Array<NestedDataRow>, row : NestedDataRow) : Array<NestedDataRow> {
      acc.push(row);
      var childRows = switch row {
        case HeaderRow(_) : [];
        case GroupRow(_, childRows) : childRows;
        case CardRow(_) : [];
      };
      acc = acc.concat(flattenNestedDataRows(childRows));
      return acc;
    }, []);
  }

  static function getNestedRowCellByCoords(row : Int, col: Int) : Option<{ row: NestedDataRow, cell: DataCell }> {
    trace(nestedDataRows);
    var flattenedNestedDataRows = flattenNestedDataRows(nestedDataRows);
    trace(flattenedNestedDataRows);
    return flattenedNestedDataRows.getOption(row)
      .flatMap(function(row : NestedDataRow) : Option<{ row: NestedDataRow, cell: DataCell }> {
        return (switch row {
          case HeaderRow(cells) : cells;
          case GroupRow(cell, childRows) : [cell];
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
    // Don't bind the `cell` to the renderer here - we want to use a lookup function, so we
    // can change the underlying data
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
      case CTextFold(text) | CText(text) : [
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
    var isFold = switch options.cell {
      case CTextFold(_) : true;
      case _ : false;
    };
    var element = Dom.create("div.ft-cell-content", children);
    if (isFold) {
      element.addEventListener("click", function(e : js.html.Event) {
        options.table.toggleRow(options.row);
      });
    }
    return element;
  }

  static function onStartEditingFlatRowCell(coords: Coords, typed: String, table: Table) {
    var value : String = getFlatRowCellByCoords(coords.row, coords.col)
      .map(data -> switch data.cell {
        case CTextFold(text) : text;
        case CText(text) : text;
        case CInt(n) : Std.string(n);
        case CFloat(n) : Std.string(n);
        case CLink(text, href) : text;
      })
      .getOrElse("");

    var input = js.Browser.document.createInputElement();
    switch typed {
      case "F2":
        input.value = value;
      case "Backspace":
        input.value = value.substring(0, value.length - 1);
      case "Delete":
        input.value = "";
      case other if(other.length == 1): // normal char
        input.value = value + typed;
      case "":
        input.value = value;
      case _:
        trace('no behavior for $typed');
        return;
    }
    thx.Timer.delay(input.focus, 10); // needed because the element is still not attached to the DOM
    input.onkeydown = function(e: js.html.KeyboardEvent) {
      e.stopPropagation();
    }
    input.onkeyup = function(e: js.html.KeyboardEvent) {
      e.stopPropagation();
      if(e.key == "Enter")
        table.renderCell(coords.row, coords.col, renderFlatRowDataCell);
    }
    input.oninput = function(e: js.html.KeyboardEvent) {
      //flat[coords.row][coords.col] = RawValue(input.value);
      setFlatRowCellByCoords(coords.row, coords.col, CText(input.value));
    }

    table.renderCell(coords.row, coords.col, CellContent.fromElement(input));
  }

  static function getCards() : Array<Card> {
    // intentional duplicates just to get a higher volume of cards
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

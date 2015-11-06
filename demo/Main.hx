import fancy.Table;

class Main {
  static function main() {
    var el = js.Browser.document.querySelector(".table-container");
    var table = new Table(el, {});
    table
      .appendRow()
      .appendRow()
      .appendColumn()
      .appendColumn();
  }
}

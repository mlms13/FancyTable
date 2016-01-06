import fancy.*;
import fancy.table.util.*;
import utest.Runner;
import utest.ui.Report;

class TestAll {
  public static function addTests(runner : Runner) {
    runner.addCase(new TestTable());
    runner.addCase(new TestNestedData());
  }

  public static function main() {
    var runner = new Runner();
    addTests(runner);
    Report.create(runner);
    runner.run();
  }
}

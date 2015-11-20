#!/bin/sh
set -e
rm -f fancytable.zip
zip -r fancytable.zip src demo bin haxelib.json LICENSE.md build.hxml test.hxml gulpfile.js package.json README.md -x "*/\.*"
haxelib submit fancytable.zip

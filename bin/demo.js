// Generated by Haxe
(function (console) { "use strict";
var HxOverrides = function() { };
HxOverrides.iter = function(a) {
	return { cur : 0, arr : a, hasNext : function() {
		return this.cur < this.arr.length;
	}, next : function() {
		return this.arr[this.cur++];
	}};
};
var Main = function() { };
Main.main = function() {
	var el = window.document.querySelector(".table-container");
	var data = [{ label : "White", data : [{ label : "Mythic", data : [{ label : "Enchantment", data : [{ label : "Quarantine Field", values : ["2","5","2.52"]}]}]},{ label : "Rare", data : [{ label : "Creature", data : [{ label : "Hero of Goma Fada", values : ["5","3.5","0.27"]},{ label : "Felidar Sovereign", values : ["6","4","0.56"]}]}]}]},{ label : "Blue", data : [{ label : "Mythic", data : [{ label : "Sorcery", data : [{ label : "Part the Waterveil", values : ["6","2.0","1.29"]}]}]},{ label : "Rare", data : [{ label : "Creature", data : [{ label : "Guardian of Tazeem", values : ["5","4.5","0.25"]}]}]}]}];
	thx_Arrays.reduce(data,function(table,curr) {
		return table.appendRow(Main.generateRow(curr));
	},new fancy_Table(el));
};
Main.generateRow = function(data) {
	if(data.values == null) data.values = []; else data.values = data.values;
	var row = thx_Arrays.reduce(data.values,function(acc,curr) {
		return acc.appendColumn(new fancy_table_Column(curr));
	},new fancy_table_Row([new fancy_table_Column(data.label)]));
	if(data.data == null) return row; else return data.data.reduce(function(row1,curr1) {
		return row1.appendRow(Main.generateRow(curr1));
	},row);
};
var Reflect = function() { };
Reflect.field = function(o,field) {
	try {
		return o[field];
	} catch( e ) {
		return null;
	}
};
Reflect.fields = function(o) {
	var a = [];
	if(o != null) {
		var hasOwnProperty = Object.prototype.hasOwnProperty;
		for( var f in o ) {
		if(f != "__id__" && f != "hx__closures__" && hasOwnProperty.call(o,f)) a.push(f);
		}
	}
	return a;
};
var fancy_Table = function(parent,options) {
	this.parent = parent;
	this.rows = [];
	this.colCount = 0;
	this.el = fancy_browser_Dom.create("div.ft-table");
	parent.appendChild(this.el);
};
fancy_Table.prototype = {
	insertRowAt: function(index,row) {
		if(row == null) row = new fancy_table_Row(null,this.colCount); else row = row;
		this.rows.splice(index,0,row);
		fancy_browser_Dom.insertChildAtIndex(this.el,row.el,index);
		return this;
	}
	,appendRow: function(row) {
		return this.insertRowAt(this.rows.length,row);
	}
};
var fancy_browser_Dom = function() { };
fancy_browser_Dom.create = function(name,attrs,children,textContent) {
	if(attrs == null) attrs = { };
	if(children == null) children = [];
	var classNames;
	if(Object.prototype.hasOwnProperty.call(attrs,"class")) classNames = Reflect.field(attrs,"class"); else classNames = "";
	var nameParts = name.split(".");
	name = nameParts.shift();
	if(nameParts.length > 0) classNames += " " + nameParts.join(" ");
	var el = window.document.createElement(name);
	var _g = 0;
	var _g1 = Reflect.fields(attrs);
	while(_g < _g1.length) {
		var att = _g1[_g];
		++_g;
		console.log(att);
		console.log(Reflect.field(attrs,att));
		el.setAttribute(att,Reflect.field(attrs,att));
	}
	el.className = classNames;
	var _g2 = 0;
	while(_g2 < children.length) {
		var child = children[_g2];
		++_g2;
		el.appendChild(child);
	}
	if(textContent != null) el.appendChild(window.document.createTextNode(textContent));
	return el;
};
fancy_browser_Dom.insertChildAtIndex = function(el,child,index) {
	el.insertBefore(child,el.children[index]);
	return el;
};
var fancy_table_Column = function(value) {
	this.el = fancy_browser_Dom.create("div.ft-col",null,null,value);
};
var fancy_table_Row = function(cols,colCount) {
	if(colCount == null) colCount = 0;
	if(cols == null) this.cols = []; else this.cols = cols;
	this.rows = [];
	this.cellsEl = fancy_browser_Dom.create("div.ft-row-values");
	this.el = fancy_browser_Dom.create("div.ft-row",null,[this.cellsEl]);
	this.cols.reduce(function(container,col,index) {
		return fancy_browser_Dom.insertChildAtIndex(container,col.el,index);
	},this.cellsEl);
	var colDiff = colCount - this.cols.length;
	if(colDiff > 0) {
		var _g = 0;
		while(_g < colDiff) {
			var i = _g++;
			this.insertColumn(i);
		}
	}
};
fancy_table_Row.prototype = {
	insertColumn: function(index,col) {
		if(col == null) col = new fancy_table_Column(); else col = col;
		this.cols.splice(index,0,col);
		fancy_browser_Dom.insertChildAtIndex(this.cellsEl,col.el,index);
		return this;
	}
	,appendColumn: function(col) {
		return this.insertColumn(this.cols.length,col);
	}
	,insertRow: function(index,row) {
		if(row == null) row = new fancy_table_Row(); else row = row;
		this.rows.splice(index,0,row);
		fancy_browser_Dom.insertChildAtIndex(this.el,row.el,index);
		return this;
	}
	,appendRow: function(row) {
		return this.insertRow(this.rows.length + 1,row);
	}
};
var thx_Arrays = function() { };
thx_Arrays.reduce = function(array,callback,initial) {
	return array.reduce(callback,initial);
};

      // Production steps of ECMA-262, Edition 5, 15.4.4.21
      // Reference: http://es5.github.io/#x15.4.4.21
      if (!Array.prototype.reduce) {
        Array.prototype.reduce = function(callback /*, initialValue*/) {
          'use strict';
          if (this == null) {
            throw new TypeError('Array.prototype.reduce called on null or undefined');
          }
          if (typeof callback !== 'function') {
            throw new TypeError(callback + ' is not a function');
          }
          var t = Object(this), len = t.length >>> 0, k = 0, value;
          if (arguments.length == 2) {
            value = arguments[1];
          } else {
            while (k < len && ! k in t) {
              k++;
            }
            if (k >= len) {
              throw new TypeError('Reduce of empty array with no initial value');
            }
            value = t[k++];
          }
          for (; k < len; k++) {
            if (k in t) {
              value = callback(value, t[k], k, t);
            }
          }
          return value;
        };
      }
    ;
Main.main();
})(typeof console != "undefined" ? console : {log:function(){}});

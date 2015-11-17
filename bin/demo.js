// Generated by Haxe
(function (console) { "use strict";
function $extend(from, fields) {
	function Inherit() {} Inherit.prototype = from; var proto = new Inherit();
	for (var name in fields) proto[name] = fields[name];
	if( fields.toString !== Object.prototype.toString ) proto.toString = fields.toString;
	return proto;
}
var EReg = function(r,opt) {
	opt = opt.split("u").join("");
	this.r = new RegExp(r,opt);
};
EReg.prototype = {
	match: function(s) {
		if(this.r.global) this.r.lastIndex = 0;
		this.r.m = this.r.exec(s);
		this.r.s = s;
		return this.r.m != null;
	}
	,replace: function(s,by) {
		return s.replace(this.r,by);
	}
};
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
	var data = [{ values : ["Cards","CMC","Draft Value","Price"]},{ values : ["White"], data : [{ values : ["Mythic"], data : [{ values : ["Enchantment"], data : [{ values : ["Quarantine Field","2","5","2.52"]}]}]},{ values : ["Rare"], data : [{ values : ["Creature"], data : [{ values : ["Hero of Goma Fada","5","3.5","0.27"]},{ values : ["Felidar Sovereign","6","4","0.56"]}]}]}]},{ values : ["Blue"], data : [{ values : ["Mythic"], data : [{ values : ["Sorcery"], data : [{ values : ["Part the Waterveil","6","2.0","1.29"]}]}]},{ values : ["Rare"], data : [{ values : ["Creature"], data : [{ values : ["Guardian of Tazeem","5","4.5","0.25"]}]}]}]}];
	var table1 = thx_Arrays.reduce(Main.rectangularize(data),function(table,curr) {
		var row1 = thx_Arrays.reducei(curr,function(row,val,index) {
			return row.setCellValue(index,val);
		},new fancy_table_Row(null,4));
		return table.appendRow(row1);
	},new fancy_Table(el)).setFixedTop().setFixedLeft();
	thx_Arrays.reduce(Main.createFolds(data)._1,function(table2,fold) {
		return table2.createFold(fold._0,fold._1);
	},table1);
};
Main.createFolds = function(data,start) {
	if(start == null) start = 0;
	return data.reduce(function(acc,row,index) {
		acc._0++;
		if(row.data != null) {
			var result = Main.createFolds(row.data,acc._0 + start);
			acc._1.push({ _0 : acc._0 + start - 1, _1 : result._0});
			acc._0 += result._0;
			acc._1 = acc._1.concat(result._1);
		}
		return acc;
	},{ _0 : 0, _1 : []});
};
Main.rectangularize = function(data) {
	return data.reduce(function(acc,d) {
		acc.push(d.values);
		if(d.data != null) return acc.concat(Main.rectangularize(d.data)); else return acc;
	},[]);
};
var Reflect = function() { };
Reflect.field = function(o,field) {
	try {
		return o[field];
	} catch( e ) {
		if (e instanceof js__$Boot_HaxeError) e = e.val;
		return null;
	}
};
Reflect.setField = function(o,field,value) {
	o[field] = value;
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
var fancy_Table = function(parent,opts) {
	var _g = this;
	var tableEl;
	this.options = this.createDefaultOptions(opts);
	this.rows = [];
	this.folds = [];
	this.fixedTop = 0;
	this.fixedLeft = 0;
	tableEl = fancy_browser_Dom.create("div.ft-table");
	this.grid = new fancy_table_GridContainer();
	tableEl.appendChild(this.grid.grid);
	fancy_browser_Dom.on(tableEl,"scroll",function(_) {
		_g.grid.positionPanes(tableEl.scrollTop,tableEl.scrollLeft);
	});
	parent.appendChild(tableEl);
};
fancy_Table.foldsIntersect = function(first,second) {
	var firstRange = thx_Ints.range(first._0,first._0 + first._1 + 1);
	var secondRange = thx_Ints.range(second._0,second._0 + second._1 + 1);
	return false;
};
fancy_Table.prototype = {
	createDefaultOptions: function(opts) {
		return thx_Objects.combine({ colCount : 0},opts == null?{ }:opts);
	}
	,insertRowAt: function(index,row) {
		if(row == null) row = new fancy_table_Row(null,this.options.colCount); else row = row;
		this.rows.splice(index,0,row);
		fancy_browser_Dom.insertChildAtIndex(this.grid.content,row.el,index);
		return this;
	}
	,appendRow: function(row) {
		return this.insertRowAt(this.rows.length,row);
	}
	,fixColumns: function(howMany,rows) {
		return rows.reduce(function(acc,row,index) {
			var newRow1 = thx_Arrays.reducei(row.cells,function(newRow,cell,index1) {
				if(index1 < howMany) {
					newRow.appendCell(new fancy_table_Cell(cell.value));
					fancy_browser_Dom.addClass(cell.el,"ft-col-fixed");
				} else fancy_browser_Dom.removeClass(cell.el,"ft-col-fixed");
				return newRow;
			},new fancy_table_Row());
			fancy_browser_Dom.addClass(newRow1.el,rows[index].el.className);
			acc.push(newRow1.el);
			return acc;
		},[]);
	}
	,setFixedTop: function(howMany) {
		if(howMany == null) howMany = 1;
		fancy_browser_Dom.empty(this.grid.top);
		thx_Arrays.reduce(this.fixColumns(this.rows[0].cells.length,this.rows.slice(0,howMany)),function(acc,child) {
			acc.appendChild(child);
			return acc;
		},this.grid.top);
		this.fixedTop = howMany;
		return this.updateFixedTopLeft();
	}
	,setFixedLeft: function(howMany) {
		if(howMany == null) howMany = 1;
		fancy_browser_Dom.empty(this.grid.left);
		var children = this.fixColumns(howMany,this.rows);
		children.reduce(function(acc,child) {
			acc.appendChild(child);
			return acc;
		},this.grid.left);
		this.fixedLeft = howMany;
		return this.updateFixedTopLeft();
	}
	,updateFixedTopLeft: function() {
		fancy_browser_Dom.empty(this.grid.topLeft);
		var cells = this.fixColumns(this.fixedLeft,this.rows.slice(0,this.fixedTop));
		cells.reduce(function(acc,child) {
			acc.appendChild(child);
			return acc;
		},this.grid.topLeft);
		return this;
	}
	,createFold: function(headerIndex,childrenCount) {
		if(headerIndex >= this.rows.length) throw new js__$Boot_HaxeError("Cannot set fold point at " + headerIndex + " because there are only " + this.rows.length + " rows");
		childrenCount = thx_Ints.min(childrenCount,this.rows.length - headerIndex);
		var _g = 0;
		var _g1 = this.folds;
		while(_g < _g1.length) {
			var fold = _g1[_g];
			++_g;
			if(fancy_Table.foldsIntersect(fold,{ _0 : headerIndex, _1 : childrenCount})) throw new js__$Boot_HaxeError("Cannot set fold point at " + headerIndex + " because it intersects with an existing fold");
		}
		var _g11 = headerIndex + 1;
		var _g2 = childrenCount + headerIndex + 1;
		while(_g11 < _g2) {
			var i = _g11++;
			this.rows[i].indent();
			this.rows[headerIndex].addChildRow(this.rows[i]);
		}
		this.folds.push({ _0 : headerIndex, _1 : childrenCount});
		return this.setFixedLeft(this.fixedLeft);
	}
};
var fancy_browser_Dom = function() { };
fancy_browser_Dom.hasClass = function(el,className) {
	var regex = new EReg("(?:^|\\s)(" + className + ")(?!\\S)","g");
	return regex.match(el.className);
};
fancy_browser_Dom.addClass = function(el,className) {
	if(!fancy_browser_Dom.hasClass(el,className)) el.className += " " + className;
	return el;
};
fancy_browser_Dom.removeClass = function(el,className) {
	var regex = new EReg("(?:^|\\s)(" + className + ")(?!\\S)","g");
	el.className = regex.replace(el.className,"");
	return el;
};
fancy_browser_Dom.on = function(el,eventName,callback) {
	el.addEventListener(eventName,callback);
	return el;
};
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
fancy_browser_Dom.prependChild = function(el,child) {
	return fancy_browser_Dom.insertChildAtIndex(el,child,0);
};
fancy_browser_Dom.empty = function(el) {
	while(el.firstChild != null) el.removeChild(el.firstChild);
	return el;
};
var fancy_table_Cell = function(value) {
	this.value = value;
	this.el = fancy_browser_Dom.create("div.ft-cell",null,null,value);
};
fancy_table_Cell.prototype = {
	setValue: function(value) {
		this.value = value;
		fancy_browser_Dom.empty(this.el).textContent = value;
	}
};
var fancy_table_GridContainer = function() {
	this.topLeft = fancy_browser_Dom.create("div.ft-table-fixed-top-left");
	this.top = fancy_browser_Dom.create("div.ft-table-fixed-top");
	this.left = fancy_browser_Dom.create("div.ft-table-fixed-left");
	this.content = fancy_browser_Dom.create("div.ft-table-content");
	this.grid = fancy_browser_Dom.create("div.ft-table-grid-contaienr");
	fancy_browser_Dom.prependChild(fancy_browser_Dom.prependChild(fancy_browser_Dom.prependChild(fancy_browser_Dom.prependChild(this.grid,this.content),this.left),this.top),this.topLeft);
};
fancy_table_GridContainer.prototype = {
	positionPanes: function(deltaTop,deltaLeft) {
		this.topLeft.style.top = "" + deltaTop + "px";
		this.topLeft.style.left = "" + deltaLeft + "px";
		this.top.style.top = "" + deltaTop + "px";
		this.left.style.left = "" + deltaLeft + "px";
	}
};
var fancy_table_Row = function(cells,colCount,options) {
	if(colCount == null) colCount = 0;
	if(cells == null) this.cells = []; else this.cells = cells;
	this.opts = this.createDefaultOptions(options);
	this.opts.classes = this.createDefaultClasses(this.opts.classes);
	this.rows = [];
	this.indentation = 0;
	this.el = thx_Arrays.reducei(this.cells,function(container,col,index) {
		return fancy_browser_Dom.insertChildAtIndex(container,col.el,index);
	},fancy_browser_Dom.create("div.ft-row"));
	var colDiff = colCount - this.cells.length;
	if(colDiff > 0) {
		var _g = 0;
		while(_g < colDiff) {
			var i = _g++;
			this.insertCell(i + this.cells.length);
		}
	}
};
fancy_table_Row.prototype = {
	createDefaultOptions: function(options) {
		return thx_Objects.combine({ expanded : true, classes : { }},options == null?{ }:options);
	}
	,createDefaultClasses: function(classes) {
		return thx_Objects.combine({ row : "ft-row", values : "ft-row-values", expanded : "ft-row-expanded", collapsed : "ft-row-collapsed", foldHeader : "ft-row-fold-header", indent : "ft-row-indent-"},classes == null?{ }:classes);
	}
	,insertCell: function(index,cell) {
		if(cell == null) cell = new fancy_table_Cell(); else cell = cell;
		this.cells.splice(index,0,cell);
		fancy_browser_Dom.insertChildAtIndex(this.el,cell.el,index);
		return this;
	}
	,appendCell: function(col) {
		return this.insertCell(this.cells.length,col);
	}
	,addChildRow: function(child) {
		fancy_browser_Dom.addClass(this.el,this.opts.classes.foldHeader);
		this.rows.push(child);
	}
	,indent: function() {
		fancy_browser_Dom.removeClass(this.el,"" + this.opts.classes.indent + this.indentation);
		this.indentation++;
		fancy_browser_Dom.addClass(this.el,"" + this.opts.classes.indent + this.indentation);
	}
	,setCellValue: function(index,value) {
		if(index >= this.cells.length) throw new js__$Boot_HaxeError("Cannot set \"" + value + "\" for cell at index " + index + ", which does not exist");
		this.cells[index].setValue(value);
		return this;
	}
};
var js__$Boot_HaxeError = function(val) {
	Error.call(this);
	this.val = val;
	this.message = String(val);
	if(Error.captureStackTrace) Error.captureStackTrace(this,js__$Boot_HaxeError);
};
js__$Boot_HaxeError.__super__ = Error;
js__$Boot_HaxeError.prototype = $extend(Error.prototype,{
});
var thx_Arrays = function() { };
thx_Arrays.reduce = function(array,callback,initial) {
	return array.reduce(callback,initial);
};
thx_Arrays.reducei = function(array,callback,initial) {
	return array.reduce(callback,initial);
};
var thx_Ints = function() { };
thx_Ints.min = function(a,b) {
	if(a < b) return a; else return b;
};
thx_Ints.range = function(start,stop,step) {
	if(step == null) step = 1;
	if(null == stop) {
		stop = start;
		start = 0;
	}
	if((stop - start) / step == Infinity) throw new js__$Boot_HaxeError("infinite range");
	var range = [];
	var i = -1;
	var j;
	if(step < 0) while((j = start + step * ++i) > stop) range.push(j); else while((j = start + step * ++i) < stop) range.push(j);
	return range;
};
var thx_Objects = function() { };
thx_Objects.combine = function(first,second) {
	var to = { };
	var _g = 0;
	var _g1 = Reflect.fields(first);
	while(_g < _g1.length) {
		var field = _g1[_g];
		++_g;
		Reflect.setField(to,field,Reflect.field(first,field));
	}
	var _g2 = 0;
	var _g11 = Reflect.fields(second);
	while(_g2 < _g11.length) {
		var field1 = _g11[_g2];
		++_g2;
		Reflect.setField(to,field1,Reflect.field(second,field1));
	}
	return to;
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

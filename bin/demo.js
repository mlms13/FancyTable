(function (console, $global) { "use strict";
var $estr = function() { return js_Boot.__string_rec(this,''); };
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
EReg.__name__ = true;
EReg.prototype = {
	match: function(s) {
		if(this.r.global) this.r.lastIndex = 0;
		this.r.m = this.r.exec(s);
		this.r.s = s;
		return this.r.m != null;
	}
	,matched: function(n) {
		if(this.r.m != null && n >= 0 && n < this.r.m.length) return this.r.m[n]; else throw new js__$Boot_HaxeError("EReg::matched");
	}
	,__class__: EReg
};
var HxOverrides = function() { };
HxOverrides.__name__ = true;
HxOverrides.cca = function(s,index) {
	var x = s.charCodeAt(index);
	if(x != x) return undefined;
	return x;
};
HxOverrides.substr = function(s,pos,len) {
	if(pos != null && pos != 0 && len != null && len < 0) return "";
	if(len == null) len = s.length;
	if(pos < 0) {
		pos = s.length + pos;
		if(pos < 0) pos = 0;
	} else if(len < 0) len = s.length + len - pos;
	return s.substr(pos,len);
};
HxOverrides.indexOf = function(a,obj,i) {
	var len = a.length;
	if(i < 0) {
		i += len;
		if(i < 0) i = 0;
	}
	while(i < len) {
		if(a[i] === obj) return i;
		i++;
	}
	return -1;
};
HxOverrides.remove = function(a,obj) {
	var i = HxOverrides.indexOf(a,obj,0);
	if(i == -1) return false;
	a.splice(i,1);
	return true;
};
HxOverrides.iter = function(a) {
	return { cur : 0, arr : a, hasNext : function() {
		return this.cur < this.arr.length;
	}, next : function() {
		return this.arr[this.cur++];
	}};
};
var Main = function() { };
Main.__name__ = true;
Main.main = function() {
	var el = window.document.querySelector(".table-container");
	var cards = [{ name : "Quarantine Field", color : "White", type : "Enchantment", rarity : "Mythic", multiverseId : "402001", cmc : 2, draftval : 5, tcgprice : 2.52},{ name : "Hero of Goma Fada", color : "White", type : "Creature", rarity : "Rare", multiverseId : "401913", cmc : 5, draftval : 3.5, tcgprice : 0.25},{ name : "Felidar Sovereign", color : "White", type : "Creature", rarity : "Rare", multiverseId : "401878", cmc : 6, draftval : 4, tcgprice : 0.56},{ name : "Part the Waterveil", color : "Blue", type : "Sorcery", rarity : "Mythic", multiverseId : "401982", cmc : 6, draftval : 2.0, tcgprice : 1.29},{ name : "Guardian of Tazeem", color : "Blue", type : "Creature", rarity : "Rare", multiverseId : "401906", cmc : 5, draftval : 4.5, tcgprice : 0.25}];
	var cardsToRowData;
	var cardsToRowData1 = null;
	cardsToRowData1 = function(cards2,groupBy) {
		return thx_Maps.tuples(thx_Arrays.groupByAppend(cards2,groupBy[0],new haxe_ds_StringMap())).map(function(tuple) {
			var restOfGroupBys = groupBy.slice(1);
			if(restOfGroupBys.length == 0) return { values : thx_Arrays.flatten(tuple._1.map(function(card4) {
				return [dots_Dom.create("span",null,[dots_Dom.create("span",null,null,card4.name),dots_Dom.create("a",(function($this) {
					var $r;
					var _g1 = new haxe_ds_StringMap();
					_g1.set("href","http://gatherer.wizards.com/Pages/Card/Details.aspx?multiverseid=" + card4.multiverseId);
					$r = _g1;
					return $r;
				}(this)),[dots_Dom.create("i.fa.fa-external-link-square")])]),fancy_table_util__$CellContent_CellContent_$Impl_$.fromString(card4.cmc == null?"null":"" + card4.cmc),fancy_table_util__$CellContent_CellContent_$Impl_$.fromString(card4.draftval == null?"null":"" + card4.draftval),fancy_table_util__$CellContent_CellContent_$Impl_$.fromString(card4.tcgprice == null?"null":"" + card4.tcgprice)];
			})), data : []}; else return { values : [dots_Dom.create("span",null,null,tuple._0)], data : cardsToRowData1(tuple._1,restOfGroupBys)};
		});
	};
	cardsToRowData = cardsToRowData1;
	var toRowData = function(cards1) {
		return [{ values : [dots_Dom.create("span",null,null,"Cards"),dots_Dom.create("span",null,null,"CMC"),dots_Dom.create("span",null,null,"Draft Value"),dots_Dom.create("span",null,null,"Price")]}].concat(cardsToRowData(cards1,[function(card) {
			return card.color;
		},function(card1) {
			return card1.rarity;
		},function(card2) {
			return card2.type;
		},function(card3) {
			return card3.name;
		}]));
	};
	var table1 = fancy_Table.fromNestedData(el,{ data : toRowData(cards), eachFold : function(table,rowIndex) {
		table.rows[rowIndex].cells[0].set_onclick(function(_) {
			table.rows[rowIndex].toggle();
		});
	}}).setFixedTop().setFixedLeft();
};
Math.__name__ = true;
var Reflect = function() { };
Reflect.__name__ = true;
Reflect.field = function(o,field) {
	try {
		return o[field];
	} catch( e ) {
		haxe_CallStack.lastException = e;
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
var Std = function() { };
Std.__name__ = true;
Std.string = function(s) {
	return js_Boot.__string_rec(s,"");
};
Std.parseInt = function(x) {
	var v = parseInt(x,10);
	if(v == 0 && (HxOverrides.cca(x,1) == 120 || HxOverrides.cca(x,1) == 88)) v = parseInt(x);
	if(isNaN(v)) return null;
	return v;
};
var StringBuf = function() {
	this.b = "";
};
StringBuf.__name__ = true;
StringBuf.prototype = {
	__class__: StringBuf
};
var StringTools = function() { };
StringTools.__name__ = true;
StringTools.isSpace = function(s,pos) {
	var c = HxOverrides.cca(s,pos);
	return c > 8 && c < 14 || c == 32;
};
StringTools.ltrim = function(s) {
	var l = s.length;
	var r = 0;
	while(r < l && StringTools.isSpace(s,r)) r++;
	if(r > 0) return HxOverrides.substr(s,r,l - r); else return s;
};
StringTools.rtrim = function(s) {
	var l = s.length;
	var r = 0;
	while(r < l && StringTools.isSpace(s,l - r - 1)) r++;
	if(r > 0) return HxOverrides.substr(s,0,l - r); else return s;
};
StringTools.trim = function(s) {
	return StringTools.ltrim(StringTools.rtrim(s));
};
var dots_AttributeType = { __ename__ : true, __constructs__ : ["BooleanAttribute","Property","BooleanProperty","OverloadedBooleanAttribute","NumericAttribute","PositiveNumericAttribute","SideEffectProperty"] };
dots_AttributeType.BooleanAttribute = ["BooleanAttribute",0];
dots_AttributeType.BooleanAttribute.toString = $estr;
dots_AttributeType.BooleanAttribute.__enum__ = dots_AttributeType;
dots_AttributeType.Property = ["Property",1];
dots_AttributeType.Property.toString = $estr;
dots_AttributeType.Property.__enum__ = dots_AttributeType;
dots_AttributeType.BooleanProperty = ["BooleanProperty",2];
dots_AttributeType.BooleanProperty.toString = $estr;
dots_AttributeType.BooleanProperty.__enum__ = dots_AttributeType;
dots_AttributeType.OverloadedBooleanAttribute = ["OverloadedBooleanAttribute",3];
dots_AttributeType.OverloadedBooleanAttribute.toString = $estr;
dots_AttributeType.OverloadedBooleanAttribute.__enum__ = dots_AttributeType;
dots_AttributeType.NumericAttribute = ["NumericAttribute",4];
dots_AttributeType.NumericAttribute.toString = $estr;
dots_AttributeType.NumericAttribute.__enum__ = dots_AttributeType;
dots_AttributeType.PositiveNumericAttribute = ["PositiveNumericAttribute",5];
dots_AttributeType.PositiveNumericAttribute.toString = $estr;
dots_AttributeType.PositiveNumericAttribute.__enum__ = dots_AttributeType;
dots_AttributeType.SideEffectProperty = ["SideEffectProperty",6];
dots_AttributeType.SideEffectProperty.toString = $estr;
dots_AttributeType.SideEffectProperty.__enum__ = dots_AttributeType;
var dots_Attributes = function() { };
dots_Attributes.__name__ = true;
dots_Attributes.setStringAttribute = function(el,name,value) {
	var prop = dots_Attributes.properties.get(name);
	if(null == value) {
		if(name == "value") el.setAttribute(name,""); else el.removeAttribute(name);
	} else if(prop == null) el.setAttribute(name,value); else switch(prop[1]) {
	case 0:case 3:case 4:case 5:
		el.setAttribute(name,value);
		break;
	case 1:case 2:case 6:
		el[name] = value;
		break;
	}
};
var dots_Dom = function() { };
dots_Dom.__name__ = true;
dots_Dom.addClass = function(el,className) {
	el.classList.add(className);
	return el;
};
dots_Dom.removeClass = function(el,className) {
	el.classList.remove(className);
	return el;
};
dots_Dom.on = function(el,eventName,handler) {
	el.addEventListener(eventName,handler);
	return el;
};
dots_Dom.off = function(el,eventName,handler) {
	el.removeEventListener(eventName,handler);
	return el;
};
dots_Dom.create = function(name,attrs,children,textContent,doc) {
	var node = dots_SelectorParser.parseSelector(name,attrs);
	if(null == doc) doc = window.document;
	var el = doc.createElement(node.tag);
	var $it0 = node.attributes.keys();
	while( $it0.hasNext() ) {
		var key = $it0.next();
		dots_Attributes.setStringAttribute(el,key,node.attributes.get(key));
	}
	if(null != children) {
		var _g = 0;
		while(_g < children.length) {
			var child = children[_g];
			++_g;
			el.appendChild(child);
		}
	}
	if(null != textContent) el.appendChild(doc.createTextNode(textContent));
	return el;
};
dots_Dom.insertAtIndex = function(el,child,index) {
	el.insertBefore(child,el.children[index]);
	return el;
};
dots_Dom.appendChild = function(el,child) {
	el.appendChild(child);
	return el;
};
dots_Dom.appendChildren = function(el,children) {
	return thx_Arrays.reduce(children,dots_Dom.appendChild,el);
};
dots_Dom.append = function(el,child,children) {
	if(child != null) dots_Dom.appendChild(el,child);
	return dots_Dom.appendChildren(el,children != null?children:[]);
};
dots_Dom.empty = function(el) {
	while(el.firstChild != null) el.removeChild(el.firstChild);
	return el;
};
var dots_SelectorParser = function(selector) {
	this.selector = selector;
	this.index = 0;
};
dots_SelectorParser.__name__ = true;
dots_SelectorParser.parseSelector = function(selector,otherAttributes) {
	var result = new dots_SelectorParser(selector).parse();
	if(otherAttributes != null) result.attributes = dots_SelectorParser.mergeAttributes(result.attributes,otherAttributes);
	return result;
};
dots_SelectorParser.mergeAttributes = function(dest,other) {
	return thx_Iterators.reduce(other.keys(),function(acc,key) {
		var value;
		value = __map_reserved[key] != null?other.getReserved(key):other.h[key];
		if(key == "class" && (__map_reserved[key] != null?acc.existsReserved(key):acc.h.hasOwnProperty(key))) {
			var previousValue;
			previousValue = __map_reserved[key] != null?acc.getReserved(key):acc.h[key];
			value = "" + previousValue.toString() + " " + value.toString();
		}
		if(__map_reserved[key] != null) acc.setReserved(key,value); else acc.h[key] = value;
		return acc;
	},dest);
};
dots_SelectorParser.prototype = {
	parse: function() {
		var tag = this.gobbleTag();
		var attributes = this.gobbleAttributes();
		return { tag : tag, attributes : attributes};
	}
	,gobbleTag: function() {
		if(this.isIdentifierStart()) return this.gobbleIdentifier(); else return "div";
	}
	,gobbleAttributes: function() {
		var attributes = new haxe_ds_StringMap();
		while(this.index < this.selector.length) {
			var attribute = this.gobbleAttribute();
			if(attribute.key == "class" && (__map_reserved["class"] != null?attributes.existsReserved("class"):attributes.h.hasOwnProperty("class"))) {
				var previousClass = (__map_reserved["class"] != null?attributes.getReserved("class"):attributes.h["class"]).toString();
				attribute.value = "" + previousClass + " " + attribute.value.toString();
			}
			attributes.set(attribute.key,attribute.value);
		}
		return attributes;
	}
	,gobbleAttribute: function() {
		var _g = this["char"]();
		var unknown = _g;
		switch(_g) {
		case "#":
			return this.gobbleElementId();
		case ".":
			return this.gobbleElementClass();
		case "[":
			return this.gobbleElementAttribute();
		default:
			throw new thx_Error("unknown selector char \"" + unknown + "\" at pos " + this.index,null,{ fileName : "SelectorParser.hx", lineNumber : 79, className : "dots.SelectorParser", methodName : "gobbleAttribute"});
		}
	}
	,gobbleElementId: function() {
		this.gobbleChar("#");
		var id = this.gobbleIdentifier();
		return { key : "id", value : id};
	}
	,gobbleElementClass: function() {
		this.gobbleChar(".");
		var id = this.gobbleIdentifier();
		return { key : "class", value : id};
	}
	,gobbleElementAttribute: function() {
		this.gobbleChar("[");
		var key = this.gobbleIdentifier();
		this.gobbleChar("=");
		var value = this.gobbleUpTo("]");
		if(thx_Bools.canParse(value.toString())) {
			if(thx_Bools.parse(value.toString())) value = key; else value = null;
		}
		this.gobbleChar("]");
		return { key : key, value : value};
	}
	,gobbleIdentifier: function() {
		var result = [];
		result.push(this.gobbleChar());
		while(this.isIdentifierPart()) result.push(this.gobbleChar());
		return result.join("");
	}
	,gobbleChar: function(expecting,expectingAnyOf) {
		var c = this.selector.charAt(this.index++);
		if(expecting != null && expecting != c) throw new thx_Error("expecting " + expecting + " at position " + this.index + " of " + this.selector,null,{ fileName : "SelectorParser.hx", lineNumber : 122, className : "dots.SelectorParser", methodName : "gobbleChar"});
		if(expectingAnyOf != null && !thx_Arrays.contains(expectingAnyOf,c)) throw new thx_Error("expecting one of " + expectingAnyOf.join(", ") + " at position " + this.index + " of " + this.selector,null,{ fileName : "SelectorParser.hx", lineNumber : 125, className : "dots.SelectorParser", methodName : "gobbleChar"});
		return c;
	}
	,gobbleUpTo: function(stopChar) {
		var result = [];
		while(this["char"]() != stopChar) result.push(this.gobbleChar());
		return result.join("");
	}
	,isAlpha: function() {
		var c = this.code();
		return c >= 65 && c <= 90 || c >= 97 && c <= 122;
	}
	,isNumeric: function() {
		var c = this.code();
		return c >= 48 && c <= 57;
	}
	,isAny: function(cs) {
		var _g = 0;
		while(_g < cs.length) {
			var c = cs[_g];
			++_g;
			if(c == this["char"]()) return true;
		}
		return false;
	}
	,isIdentifierStart: function() {
		return this.isAlpha();
	}
	,isIdentifierPart: function() {
		return this.isAlpha() || this.isNumeric() || this.isAny(["_","-"]);
	}
	,'char': function() {
		return this.selector.charAt(this.index);
	}
	,code: function() {
		return HxOverrides.cca(this.selector,this.index);
	}
	,__class__: dots_SelectorParser
};
var fancy_Table = function(parent,options) {
	var _g = this;
	this.settings = this.createDefaultOptions(options);
	this.settings.classes = this.createDefaultClasses(this.settings.classes);
	this.tableEl = dots_Dom.addClass(dots_Dom.create("div"),this.settings.classes.table);
	this.grid = new fancy_table_GridContainer();
	this.tableEl.appendChild(this.grid.grid);
	dots_Dom.on(this.tableEl,"scroll",function(_) {
		_g.grid.positionPanes(_g.tableEl.scrollTop,_g.tableEl.scrollLeft);
		if(_g.tableEl.scrollTop == 0) dots_Dom.removeClass(_g.tableEl,_g.settings.classes.scrollV); else dots_Dom.addClass(_g.tableEl,_g.settings.classes.scrollV);
		if(_g.tableEl.scrollLeft == 0) dots_Dom.removeClass(_g.tableEl,_g.settings.classes.scrollH); else dots_Dom.addClass(_g.tableEl,_g.settings.classes.scrollH);
	});
	this.setData(this.settings.data);
	parent.appendChild(this.tableEl);
};
fancy_Table.__name__ = true;
fancy_Table.findExistingFolds = function(a,b) {
	return thx_Arrays.filterNull(thx_Ints.range(b._0 + 1,b._0 + b._1 + 1).map(function(index) {
		if(index > a._0 && index <= a._1 + a._0) return { _0 : a._0, _1 : index}; else return null;
	}));
};
fancy_Table.fromNestedData = function(parent,options) {
	return new fancy_Table(parent).setNestedData(options.data,options.eachFold);
};
fancy_Table.prototype = {
	createDefaultOptions: function(options) {
		return thx_Objects.combine({ classes : { }, colCount : 0, data : []},options == null?{ }:options);
	}
	,createDefaultClasses: function(classes) {
		return thx_Objects.combine({ table : "ft-table", scrollH : "ft-table-scroll-horizontal", scrollV : "ft-table-scroll-vertical"},classes == null?{ }:classes);
	}
	,empty: function() {
		this.grid.empty();
		this.rows = [];
		this.folds = [];
		this.fixedTop = 0;
		this.fixedLeft = 0;
		this.settings.data = [];
		return this.setColCount(0);
	}
	,setData: function(data) {
		if(data != null) data = data; else data = [];
		return thx_Arrays.reduce(data,function(table,curr) {
			var row1 = thx_Arrays.reduce(curr,function(row,val) {
				return row.appendCell(new fancy_table_Cell(val));
			},new fancy_table_Row());
			return table.appendRow(row1);
		},this.empty());
	}
	,setNestedData: function(data,eachFold) {
		var _g = this;
		this.setData(fancy_table_util_NestedData.rectangularize(data));
		thx_Arrays.reduce((function($this) {
			var $r;
			var this1 = fancy_table_util_NestedData.generateFolds(data);
			$r = this1._1;
			return $r;
		}(this)),function(table,fold) {
			if(eachFold != null) eachFold(table,fold._0);
			return table.createFold(fold._0,fold._1);
		},this);
		fancy_table_util_NestedData.iterate(data,function(row,index) {
			if(row.meta != null && row.meta.classes != null) _g.rows[index].setCustomClass(row.meta.classes.join(" "));
			if(row.meta != null && row.meta.collapsed) _g.rows[index].collapse();
		});
		return this;
	}
	,insertRowAt: function(index,row) {
		if(row == null) row = new fancy_table_Row(null,{ colCount : this.settings.colCount}); else row = row;
		row.fillWithCells(thx_Ints.max(0,this.settings.colCount - row.cells.length));
		this.setColCount(row.cells.length);
		this.rows.splice(index,0,row);
		dots_Dom.insertAtIndex(this.grid.content,row.el,index);
		return this;
	}
	,appendRow: function(row) {
		return this.insertRowAt(this.rows.length,row);
	}
	,setColCount: function(howMany) {
		var _g = this;
		if(howMany > this.settings.colCount) this.rows.map(function(row) {
			row.fillWithCells(howMany - _g.settings.colCount);
		});
		dots_Dom.addClass(dots_Dom.removeClass(this.tableEl,"ft-table-" + this.settings.colCount + "-col"),"ft-table-" + howMany + "-col");
		this.settings.colCount = howMany;
		return this;
	}
	,setFixedTop: function(howMany) {
		if(howMany == null) howMany = 1;
		var _g1 = thx_Ints.min(howMany,this.fixedTop);
		var _g = thx_Ints.max(howMany,this.fixedTop);
		while(_g1 < _g) {
			var i = _g1++;
		}
		dots_Dom.append(dots_Dom.empty(this.grid.top),null,this.rows.slice(0,howMany).map(function(row) {
			return row.copy().el;
		}));
		this.fixedTop = howMany;
		return this.updateFixedTopLeft();
	}
	,setFixedLeft: function(howMany) {
		if(howMany == null) howMany = 1;
		dots_Dom.append(dots_Dom.empty(this.grid.left),null,this.rows.map(function(row) {
			return row.updateFixedCells(howMany);
		}));
		this.fixedLeft = howMany;
		return this.updateFixedTopLeft();
	}
	,updateFixedTopLeft: function() {
		var _g = this;
		dots_Dom.append(dots_Dom.empty(this.grid.topLeft),null,this.rows.slice(0,this.fixedTop).map(function(row) {
			return row.copy().updateFixedCells(_g.fixedLeft);
		}));
		return this;
	}
	,createFold: function(headerIndex,childrenCount) {
		var _g2 = this;
		if(headerIndex >= this.rows.length) throw new js__$Boot_HaxeError("Cannot set fold point at " + headerIndex + " because there are only " + this.rows.length + " rows");
		childrenCount = thx_Ints.min(childrenCount,this.rows.length - headerIndex);
		var _g = 0;
		var _g1 = this.folds;
		while(_g < _g1.length) {
			var fold = _g1[_g];
			++_g;
			if(fold._0 == headerIndex) throw new js__$Boot_HaxeError("Cannot set fold point at " + headerIndex + " because that row is already a fold header");
			if(fancy_table_util_NestedData.foldsIntersect(fold,{ _0 : headerIndex, _1 : childrenCount})) throw new js__$Boot_HaxeError("Cannot set fold point at " + headerIndex + " because it intersects with an existing fold");
			fancy_Table.findExistingFolds(fold,{ _0 : headerIndex, _1 : childrenCount}).map(function(fold1) {
				_g2.rows[fold1._0].removeChildRow(_g2.rows[fold1._1]);
			});
		}
		var _g11 = headerIndex + 1;
		var _g3 = childrenCount + headerIndex + 1;
		while(_g11 < _g3) {
			var i = _g11++;
			this.rows[i].indent();
			this.rows[headerIndex].addChildRow(this.rows[i]);
		}
		this.folds.push({ _0 : headerIndex, _1 : childrenCount});
		if(this.fixedLeft > 0) return this.setFixedLeft(this.fixedLeft); else return this;
	}
	,__class__: fancy_Table
};
var fancy_table_Cell = function(value,fixed,onclick) {
	if(fixed == null) fixed = false;
	this.el = dots_Dom.create("div.ft-cell");
	this.set_onclick(onclick != null?onclick:function(_) {
	});
	this.set_value(value != null?value:dots_Dom.create("span",null,null,""));
	this.set_fixed(fixed);
};
fancy_table_Cell.__name__ = true;
fancy_table_Cell.prototype = {
	set_fixed: function(value) {
		if(value) dots_Dom.addClass(this.el,"ft-col-fixed"); else dots_Dom.removeClass(this.el,"ft-col-fixed");
		return this.fixed = value;
	}
	,set_value: function(value) {
		dots_Dom.append(dots_Dom.empty(this.el),value);
		return this.value = value;
	}
	,set_onclick: function(fn) {
		dots_Dom.off(this.el,"click",this.onclick);
		dots_Dom.on(this.el,"click",fn);
		return this.onclick = fn;
	}
	,copy: function(returnOriginalElement) {
		if(returnOriginalElement == null) returnOriginalElement = true;
		var cloned = this.value.cloneNode(true);
		var instance = new fancy_table_Cell(returnOriginalElement?this.value:cloned,this.fixed,this.onclick);
		if(returnOriginalElement) this.set_value(cloned);
		return instance;
	}
	,__class__: fancy_table_Cell
};
var fancy_table_GridContainer = function() {
	this.topLeft = dots_Dom.create("div.ft-table-fixed-top-left");
	this.top = dots_Dom.create("div.ft-table-fixed-top");
	this.left = dots_Dom.create("div.ft-table-fixed-left");
	this.content = dots_Dom.create("div.ft-table-content");
	this.grid = dots_Dom.create("div.ft-table-grid-container");
	dots_Dom.append(dots_Dom.append(dots_Dom.append(dots_Dom.append(this.grid,this.topLeft),this.top),this.left),this.content);
};
fancy_table_GridContainer.__name__ = true;
fancy_table_GridContainer.prototype = {
	positionPanes: function(deltaTop,deltaLeft) {
		this.topLeft.style.top = "" + deltaTop + "px";
		this.topLeft.style.left = "" + deltaLeft + "px";
		this.top.style.top = "" + deltaTop + "px";
		this.left.style.left = "" + deltaLeft + "px";
	}
	,empty: function() {
		dots_Dom.empty(this.topLeft);
		dots_Dom.empty(this.top);
		dots_Dom.empty(this.left);
		dots_Dom.empty(this.content);
	}
	,__class__: fancy_table_GridContainer
};
var fancy_table_Row = function(cells,options) {
	if(cells == null) this.cells = []; else this.cells = cells;
	this.settings = this.createDefaultOptions(options);
	this.settings.classes = this.createDefaultClasses(this.settings.classes);
	this.rows = [];
	this.el = this.createRowElement(this.cells);
	var colDiff = thx_Ints.max(0,this.settings.colCount - this.cells.length);
	this.fillWithCells(colDiff);
};
fancy_table_Row.__name__ = true;
fancy_table_Row.prototype = {
	createDefaultOptions: function(options) {
		return thx_Objects.combine({ classes : { }, colCount : 0, expanded : true, hidden : false, fixedCellCount : 0, indentation : 0},options == null?{ }:options);
	}
	,createDefaultClasses: function(classes) {
		return thx_Objects.combine({ row : "ft-row", expanded : "ft-row-expanded", collapsed : "ft-row-collapsed", foldHeader : "ft-row-fold-header", hidden : "ft-row-hidden", indent : "ft-row-indent-", custom : ""},classes == null?{ }:classes);
	}
	,createRowElement: function(children) {
		var childElements = (children != null?children:[]).map(function(_) {
			return _.el;
		});
		return dots_Dom.addClass(dots_Dom.addClass(dots_Dom.addClass(dots_Dom.addClass(dots_Dom.addClass(dots_Dom.create("div",(function($this) {
			var $r;
			var _g = new haxe_ds_StringMap();
			_g.set("class",$this.settings.classes.row);
			$r = _g;
			return $r;
		}(this)),childElements),this.settings.expanded?this.settings.classes.expanded:this.settings.classes.collapsed),this.settings.hidden?this.settings.classes.hidden:""),"" + this.settings.classes.indent + this.settings.indentation),this.settings.classes.custom),this.rows.length == 0?"":this.settings.classes.foldHeader);
	}
	,updateFixedCells: function(count) {
		var _g = this;
		var _g1 = thx_Ints.min(count,this.settings.fixedCellCount);
		var _g2 = thx_Ints.max(count,this.settings.fixedCellCount);
		while(_g1 < _g2) {
			var i = _g1++;
			this.cells[i].set_fixed(count > this.settings.fixedCellCount);
		}
		this.settings.fixedCellCount = count;
		this.fixedEl = thx_Arrays.reduce(thx_Ints.range(0,count),function(parent,index) {
			var cell = _g.cells[index].copy();
			cell.set_fixed(false);
			return dots_Dom.append(parent,cell.el);
		},this.createRowElement());
		return this.fixedEl;
	}
	,insertCell: function(index,cell) {
		if(cell == null) cell = new fancy_table_Cell(); else cell = cell;
		this.cells.splice(index,0,cell);
		dots_Dom.insertAtIndex(this.el,cell.el,index);
		return this;
	}
	,addRowClass: function(className) {
		dots_Dom.addClass(this.el,className);
		if(this.fixedEl != null) dots_Dom.addClass(this.fixedEl,className);
		return this;
	}
	,removeRowClass: function(className) {
		dots_Dom.removeClass(this.el,className);
		if(this.fixedEl != null) dots_Dom.removeClass(this.fixedEl,className);
		return this;
	}
	,setCustomClass: function(className) {
		this.removeRowClass(this.settings.classes.custom);
		this.settings.classes.custom = className;
		return this.addRowClass(className);
	}
	,appendCell: function(col) {
		return this.insertCell(this.cells.length,col);
	}
	,fillWithCells: function(howMany) {
		var _g = this;
		return thx_Arrays.reduce(thx_Ints.range(0,howMany),function(_,_1) {
			return _g.appendCell();
		},this);
	}
	,addChildRow: function(child) {
		this.addRowClass(this.settings.classes.foldHeader);
		this.rows.push(child);
	}
	,removeChildRow: function(child) {
		HxOverrides.remove(this.rows,child);
		if(this.rows.length == 0) this.removeRowClass(this.settings.classes.foldHeader);
	}
	,indent: function() {
		this.removeRowClass("" + this.settings.classes.indent + this.settings.indentation);
		this.settings.indentation++;
		this.addRowClass("" + this.settings.classes.indent + this.settings.indentation);
	}
	,expand: function() {
		this.settings.expanded = true;
		this.removeRowClass(this.settings.classes.collapsed).addRowClass(this.settings.classes.expanded);
		this.rows.map(function(_) {
			return _.show();
		});
	}
	,collapse: function() {
		this.settings.expanded = false;
		this.removeRowClass(this.settings.classes.expanded).addRowClass(this.settings.classes.collapsed);
		this.rows.map(function(_) {
			return _.hide();
		});
	}
	,toggle: function() {
		if(this.settings.expanded) this.collapse(); else this.expand();
	}
	,hide: function() {
		this.settings.hidden = true;
		this.rows.map(function(_) {
			return _.hide();
		});
		return this.addRowClass(this.settings.classes.hidden);
	}
	,show: function() {
		this.settings.hidden = false;
		if(this.settings.expanded) this.rows.map(function(_) {
			return _.show();
		});
		return this.removeRowClass(this.settings.classes.hidden);
	}
	,copy: function() {
		return new fancy_table_Row(this.cells.map(function(_) {
			return _.copy();
		}),this.settings);
	}
	,__class__: fancy_table_Row
};
var fancy_table_util__$CellContent_CellContent_$Impl_$ = {};
fancy_table_util__$CellContent_CellContent_$Impl_$.__name__ = true;
fancy_table_util__$CellContent_CellContent_$Impl_$.fromString = function(s) {
	return dots_Dom.create("span",null,null,s);
};
var fancy_table_util_NestedData = function() { };
fancy_table_util_NestedData.__name__ = true;
fancy_table_util_NestedData.rectangularize = function(data) {
	return thx_Arrays.reduce(data,function(acc,d) {
		acc.push(d.values);
		if(d.data != null) return acc.concat(fancy_table_util_NestedData.rectangularize(d.data)); else return acc;
	},[]);
};
fancy_table_util_NestedData.iterate = function(data,fn,start) {
	if(start == null) start = 0;
	return thx_Arrays.reduce(data,function(acc,row) {
		fn(row,acc);
		acc++;
		if(row.data != null) return fancy_table_util_NestedData.iterate(row.data,fn,acc); else return acc;
	},start);
};
fancy_table_util_NestedData.generateFolds = function(data,start) {
	if(start == null) start = 0;
	return thx_Arrays.reducei(data,function(acc,row,index) {
		acc._0++;
		if(row.data != null) {
			var result = fancy_table_util_NestedData.generateFolds(row.data,acc._0 + start);
			acc._1.push({ _0 : acc._0 + start - 1, _1 : result._0});
			acc._0 += result._0;
			acc._1 = acc._1.concat(result._1);
		}
		return acc;
	},{ _0 : 0, _1 : []});
};
fancy_table_util_NestedData.foldsIntersect = function(a,b) {
	var first;
	if(a._0 <= b._0) first = a; else first = b;
	var second;
	if(first == a) second = b; else second = a;
	return first._0 < second._0 && second._0 <= first._0 + first._1 && second._0 + second._1 > first._0 + first._1;
};
var haxe_StackItem = { __ename__ : true, __constructs__ : ["CFunction","Module","FilePos","Method","LocalFunction"] };
haxe_StackItem.CFunction = ["CFunction",0];
haxe_StackItem.CFunction.toString = $estr;
haxe_StackItem.CFunction.__enum__ = haxe_StackItem;
haxe_StackItem.Module = function(m) { var $x = ["Module",1,m]; $x.__enum__ = haxe_StackItem; $x.toString = $estr; return $x; };
haxe_StackItem.FilePos = function(s,file,line) { var $x = ["FilePos",2,s,file,line]; $x.__enum__ = haxe_StackItem; $x.toString = $estr; return $x; };
haxe_StackItem.Method = function(classname,method) { var $x = ["Method",3,classname,method]; $x.__enum__ = haxe_StackItem; $x.toString = $estr; return $x; };
haxe_StackItem.LocalFunction = function(v) { var $x = ["LocalFunction",4,v]; $x.__enum__ = haxe_StackItem; $x.toString = $estr; return $x; };
var haxe_CallStack = function() { };
haxe_CallStack.__name__ = true;
haxe_CallStack.getStack = function(e) {
	if(e == null) return [];
	var oldValue = Error.prepareStackTrace;
	Error.prepareStackTrace = function(error,callsites) {
		var stack = [];
		var _g = 0;
		while(_g < callsites.length) {
			var site = callsites[_g];
			++_g;
			if(haxe_CallStack.wrapCallSite != null) site = haxe_CallStack.wrapCallSite(site);
			var method = null;
			var fullName = site.getFunctionName();
			if(fullName != null) {
				var idx = fullName.lastIndexOf(".");
				if(idx >= 0) {
					var className = HxOverrides.substr(fullName,0,idx);
					var methodName = HxOverrides.substr(fullName,idx + 1,null);
					method = haxe_StackItem.Method(className,methodName);
				}
			}
			stack.push(haxe_StackItem.FilePos(method,site.getFileName(),site.getLineNumber()));
		}
		return stack;
	};
	var a = haxe_CallStack.makeStack(e.stack);
	Error.prepareStackTrace = oldValue;
	return a;
};
haxe_CallStack.callStack = function() {
	try {
		throw new Error();
	} catch( e ) {
		haxe_CallStack.lastException = e;
		if (e instanceof js__$Boot_HaxeError) e = e.val;
		var a = haxe_CallStack.getStack(e);
		a.shift();
		return a;
	}
};
haxe_CallStack.exceptionStack = function() {
	return haxe_CallStack.getStack(haxe_CallStack.lastException);
};
haxe_CallStack.toString = function(stack) {
	var b = new StringBuf();
	var _g = 0;
	while(_g < stack.length) {
		var s = stack[_g];
		++_g;
		b.b += "\nCalled from ";
		haxe_CallStack.itemToString(b,s);
	}
	return b.b;
};
haxe_CallStack.itemToString = function(b,s) {
	switch(s[1]) {
	case 0:
		b.b += "a C function";
		break;
	case 1:
		var m = s[2];
		b.b += "module ";
		if(m == null) b.b += "null"; else b.b += "" + m;
		break;
	case 2:
		var line = s[4];
		var file = s[3];
		var s1 = s[2];
		if(s1 != null) {
			haxe_CallStack.itemToString(b,s1);
			b.b += " (";
		}
		if(file == null) b.b += "null"; else b.b += "" + file;
		b.b += " line ";
		if(line == null) b.b += "null"; else b.b += "" + line;
		if(s1 != null) b.b += ")";
		break;
	case 3:
		var meth = s[3];
		var cname = s[2];
		if(cname == null) b.b += "null"; else b.b += "" + cname;
		b.b += ".";
		if(meth == null) b.b += "null"; else b.b += "" + meth;
		break;
	case 4:
		var n = s[2];
		b.b += "local function #";
		if(n == null) b.b += "null"; else b.b += "" + n;
		break;
	}
};
haxe_CallStack.makeStack = function(s) {
	if(s == null) return []; else if(typeof(s) == "string") {
		var stack = s.split("\n");
		if(stack[0] == "Error") stack.shift();
		var m = [];
		var rie10 = new EReg("^   at ([A-Za-z0-9_. ]+) \\(([^)]+):([0-9]+):([0-9]+)\\)$","");
		var _g = 0;
		while(_g < stack.length) {
			var line = stack[_g];
			++_g;
			if(rie10.match(line)) {
				var path = rie10.matched(1).split(".");
				var meth = path.pop();
				var file = rie10.matched(2);
				var line1 = Std.parseInt(rie10.matched(3));
				m.push(haxe_StackItem.FilePos(meth == "Anonymous function"?haxe_StackItem.LocalFunction():meth == "Global code"?null:haxe_StackItem.Method(path.join("."),meth),file,line1));
			} else m.push(haxe_StackItem.Module(StringTools.trim(line)));
		}
		return m;
	} else return s;
};
var haxe_IMap = function() { };
haxe_IMap.__name__ = true;
haxe_IMap.prototype = {
	__class__: haxe_IMap
};
var haxe__$Int64__$_$_$Int64 = function(high,low) {
	this.high = high;
	this.low = low;
};
haxe__$Int64__$_$_$Int64.__name__ = true;
haxe__$Int64__$_$_$Int64.prototype = {
	__class__: haxe__$Int64__$_$_$Int64
};
var haxe_ds_StringMap = function() {
	this.h = { };
};
haxe_ds_StringMap.__name__ = true;
haxe_ds_StringMap.__interfaces__ = [haxe_IMap];
haxe_ds_StringMap.prototype = {
	set: function(key,value) {
		if(__map_reserved[key] != null) this.setReserved(key,value); else this.h[key] = value;
	}
	,get: function(key) {
		if(__map_reserved[key] != null) return this.getReserved(key);
		return this.h[key];
	}
	,setReserved: function(key,value) {
		if(this.rh == null) this.rh = { };
		this.rh["$" + key] = value;
	}
	,getReserved: function(key) {
		if(this.rh == null) return null; else return this.rh["$" + key];
	}
	,existsReserved: function(key) {
		if(this.rh == null) return false;
		return this.rh.hasOwnProperty("$" + key);
	}
	,keys: function() {
		var _this = this.arrayKeys();
		return HxOverrides.iter(_this);
	}
	,arrayKeys: function() {
		var out = [];
		for( var key in this.h ) {
		if(this.h.hasOwnProperty(key)) out.push(key);
		}
		if(this.rh != null) {
			for( var key in this.rh ) {
			if(key.charCodeAt(0) == 36) out.push(key.substr(1));
			}
		}
		return out;
	}
	,__class__: haxe_ds_StringMap
};
var haxe_io_Error = { __ename__ : true, __constructs__ : ["Blocked","Overflow","OutsideBounds","Custom"] };
haxe_io_Error.Blocked = ["Blocked",0];
haxe_io_Error.Blocked.toString = $estr;
haxe_io_Error.Blocked.__enum__ = haxe_io_Error;
haxe_io_Error.Overflow = ["Overflow",1];
haxe_io_Error.Overflow.toString = $estr;
haxe_io_Error.Overflow.__enum__ = haxe_io_Error;
haxe_io_Error.OutsideBounds = ["OutsideBounds",2];
haxe_io_Error.OutsideBounds.toString = $estr;
haxe_io_Error.OutsideBounds.__enum__ = haxe_io_Error;
haxe_io_Error.Custom = function(e) { var $x = ["Custom",3,e]; $x.__enum__ = haxe_io_Error; $x.toString = $estr; return $x; };
var haxe_io_FPHelper = function() { };
haxe_io_FPHelper.__name__ = true;
haxe_io_FPHelper.i32ToFloat = function(i) {
	var sign = 1 - (i >>> 31 << 1);
	var exp = i >>> 23 & 255;
	var sig = i & 8388607;
	if(sig == 0 && exp == 0) return 0.0;
	return sign * (1 + Math.pow(2,-23) * sig) * Math.pow(2,exp - 127);
};
haxe_io_FPHelper.floatToI32 = function(f) {
	if(f == 0) return 0;
	var af;
	if(f < 0) af = -f; else af = f;
	var exp = Math.floor(Math.log(af) / 0.6931471805599453);
	if(exp < -127) exp = -127; else if(exp > 128) exp = 128;
	var sig = Math.round((af / Math.pow(2,exp) - 1) * 8388608) & 8388607;
	return (f < 0?-2147483648:0) | exp + 127 << 23 | sig;
};
haxe_io_FPHelper.i64ToDouble = function(low,high) {
	var sign = 1 - (high >>> 31 << 1);
	var exp = (high >> 20 & 2047) - 1023;
	var sig = (high & 1048575) * 4294967296. + (low >>> 31) * 2147483648. + (low & 2147483647);
	if(sig == 0 && exp == -1023) return 0.0;
	return sign * (1.0 + Math.pow(2,-52) * sig) * Math.pow(2,exp);
};
haxe_io_FPHelper.doubleToI64 = function(v) {
	var i64 = haxe_io_FPHelper.i64tmp;
	if(v == 0) {
		i64.low = 0;
		i64.high = 0;
	} else {
		var av;
		if(v < 0) av = -v; else av = v;
		var exp = Math.floor(Math.log(av) / 0.6931471805599453);
		var sig;
		var v1 = (av / Math.pow(2,exp) - 1) * 4503599627370496.;
		sig = Math.round(v1);
		var sig_l = sig | 0;
		var sig_h = sig / 4294967296.0 | 0;
		i64.low = sig_l;
		i64.high = (v < 0?-2147483648:0) | exp + 1023 << 20 | sig_h;
	}
	return i64;
};
var js__$Boot_HaxeError = function(val) {
	Error.call(this);
	this.val = val;
	this.message = String(val);
	if(Error.captureStackTrace) Error.captureStackTrace(this,js__$Boot_HaxeError);
};
js__$Boot_HaxeError.__name__ = true;
js__$Boot_HaxeError.__super__ = Error;
js__$Boot_HaxeError.prototype = $extend(Error.prototype,{
	__class__: js__$Boot_HaxeError
});
var js_Boot = function() { };
js_Boot.__name__ = true;
js_Boot.getClass = function(o) {
	if((o instanceof Array) && o.__enum__ == null) return Array; else {
		var cl = o.__class__;
		if(cl != null) return cl;
		var name = js_Boot.__nativeClassName(o);
		if(name != null) return js_Boot.__resolveNativeClass(name);
		return null;
	}
};
js_Boot.__string_rec = function(o,s) {
	if(o == null) return "null";
	if(s.length >= 5) return "<...>";
	var t = typeof(o);
	if(t == "function" && (o.__name__ || o.__ename__)) t = "object";
	switch(t) {
	case "object":
		if(o instanceof Array) {
			if(o.__enum__) {
				if(o.length == 2) return o[0];
				var str2 = o[0] + "(";
				s += "\t";
				var _g1 = 2;
				var _g = o.length;
				while(_g1 < _g) {
					var i1 = _g1++;
					if(i1 != 2) str2 += "," + js_Boot.__string_rec(o[i1],s); else str2 += js_Boot.__string_rec(o[i1],s);
				}
				return str2 + ")";
			}
			var l = o.length;
			var i;
			var str1 = "[";
			s += "\t";
			var _g2 = 0;
			while(_g2 < l) {
				var i2 = _g2++;
				str1 += (i2 > 0?",":"") + js_Boot.__string_rec(o[i2],s);
			}
			str1 += "]";
			return str1;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( e ) {
			haxe_CallStack.lastException = e;
			if (e instanceof js__$Boot_HaxeError) e = e.val;
			return "???";
		}
		if(tostr != null && tostr != Object.toString && typeof(tostr) == "function") {
			var s2 = o.toString();
			if(s2 != "[object Object]") return s2;
		}
		var k = null;
		var str = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		for( var k in o ) {
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str.length != 2) str += ", \n";
		str += s + k + " : " + js_Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str += "\n" + s + "}";
		return str;
	case "function":
		return "<function>";
	case "string":
		return o;
	default:
		return String(o);
	}
};
js_Boot.__interfLoop = function(cc,cl) {
	if(cc == null) return false;
	if(cc == cl) return true;
	var intf = cc.__interfaces__;
	if(intf != null) {
		var _g1 = 0;
		var _g = intf.length;
		while(_g1 < _g) {
			var i = _g1++;
			var i1 = intf[i];
			if(i1 == cl || js_Boot.__interfLoop(i1,cl)) return true;
		}
	}
	return js_Boot.__interfLoop(cc.__super__,cl);
};
js_Boot.__instanceof = function(o,cl) {
	if(cl == null) return false;
	switch(cl) {
	case Int:
		return (o|0) === o;
	case Float:
		return typeof(o) == "number";
	case Bool:
		return typeof(o) == "boolean";
	case String:
		return typeof(o) == "string";
	case Array:
		return (o instanceof Array) && o.__enum__ == null;
	case Dynamic:
		return true;
	default:
		if(o != null) {
			if(typeof(cl) == "function") {
				if(o instanceof cl) return true;
				if(js_Boot.__interfLoop(js_Boot.getClass(o),cl)) return true;
			} else if(typeof(cl) == "object" && js_Boot.__isNativeObj(cl)) {
				if(o instanceof cl) return true;
			}
		} else return false;
		if(cl == Class && o.__name__ != null) return true;
		if(cl == Enum && o.__ename__ != null) return true;
		return o.__enum__ == cl;
	}
};
js_Boot.__nativeClassName = function(o) {
	var name = js_Boot.__toStr.call(o).slice(8,-1);
	if(name == "Object" || name == "Function" || name == "Math" || name == "JSON") return null;
	return name;
};
js_Boot.__isNativeObj = function(o) {
	return js_Boot.__nativeClassName(o) != null;
};
js_Boot.__resolveNativeClass = function(name) {
	return $global[name];
};
var js_html_compat_ArrayBuffer = function(a) {
	if((a instanceof Array) && a.__enum__ == null) {
		this.a = a;
		this.byteLength = a.length;
	} else {
		var len = a;
		this.a = [];
		var _g = 0;
		while(_g < len) {
			var i = _g++;
			this.a[i] = 0;
		}
		this.byteLength = len;
	}
};
js_html_compat_ArrayBuffer.__name__ = true;
js_html_compat_ArrayBuffer.sliceImpl = function(begin,end) {
	var u = new Uint8Array(this,begin,end == null?null:end - begin);
	var result = new ArrayBuffer(u.byteLength);
	var resultArray = new Uint8Array(result);
	resultArray.set(u);
	return result;
};
js_html_compat_ArrayBuffer.prototype = {
	slice: function(begin,end) {
		return new js_html_compat_ArrayBuffer(this.a.slice(begin,end));
	}
	,__class__: js_html_compat_ArrayBuffer
};
var js_html_compat_DataView = function(buffer,byteOffset,byteLength) {
	this.buf = buffer;
	if(byteOffset == null) this.offset = 0; else this.offset = byteOffset;
	if(byteLength == null) this.length = buffer.byteLength - this.offset; else this.length = byteLength;
	if(this.offset < 0 || this.length < 0 || this.offset + this.length > buffer.byteLength) throw new js__$Boot_HaxeError(haxe_io_Error.OutsideBounds);
};
js_html_compat_DataView.__name__ = true;
js_html_compat_DataView.prototype = {
	getInt8: function(byteOffset) {
		var v = this.buf.a[this.offset + byteOffset];
		if(v >= 128) return v - 256; else return v;
	}
	,getUint8: function(byteOffset) {
		return this.buf.a[this.offset + byteOffset];
	}
	,getInt16: function(byteOffset,littleEndian) {
		var v = this.getUint16(byteOffset,littleEndian);
		if(v >= 32768) return v - 65536; else return v;
	}
	,getUint16: function(byteOffset,littleEndian) {
		if(littleEndian) return this.buf.a[this.offset + byteOffset] | this.buf.a[this.offset + byteOffset + 1] << 8; else return this.buf.a[this.offset + byteOffset] << 8 | this.buf.a[this.offset + byteOffset + 1];
	}
	,getInt32: function(byteOffset,littleEndian) {
		var p = this.offset + byteOffset;
		var a = this.buf.a[p++];
		var b = this.buf.a[p++];
		var c = this.buf.a[p++];
		var d = this.buf.a[p++];
		if(littleEndian) return a | b << 8 | c << 16 | d << 24; else return d | c << 8 | b << 16 | a << 24;
	}
	,getUint32: function(byteOffset,littleEndian) {
		var v = this.getInt32(byteOffset,littleEndian);
		if(v < 0) return v + 4294967296.; else return v;
	}
	,getFloat32: function(byteOffset,littleEndian) {
		return haxe_io_FPHelper.i32ToFloat(this.getInt32(byteOffset,littleEndian));
	}
	,getFloat64: function(byteOffset,littleEndian) {
		var a = this.getInt32(byteOffset,littleEndian);
		var b = this.getInt32(byteOffset + 4,littleEndian);
		return haxe_io_FPHelper.i64ToDouble(littleEndian?a:b,littleEndian?b:a);
	}
	,setInt8: function(byteOffset,value) {
		if(value < 0) this.buf.a[byteOffset + this.offset] = value + 128 & 255; else this.buf.a[byteOffset + this.offset] = value & 255;
	}
	,setUint8: function(byteOffset,value) {
		this.buf.a[byteOffset + this.offset] = value & 255;
	}
	,setInt16: function(byteOffset,value,littleEndian) {
		this.setUint16(byteOffset,value < 0?value + 65536:value,littleEndian);
	}
	,setUint16: function(byteOffset,value,littleEndian) {
		var p = byteOffset + this.offset;
		if(littleEndian) {
			this.buf.a[p] = value & 255;
			this.buf.a[p++] = value >> 8 & 255;
		} else {
			this.buf.a[p++] = value >> 8 & 255;
			this.buf.a[p] = value & 255;
		}
	}
	,setInt32: function(byteOffset,value,littleEndian) {
		this.setUint32(byteOffset,value,littleEndian);
	}
	,setUint32: function(byteOffset,value,littleEndian) {
		var p = byteOffset + this.offset;
		if(littleEndian) {
			this.buf.a[p++] = value & 255;
			this.buf.a[p++] = value >> 8 & 255;
			this.buf.a[p++] = value >> 16 & 255;
			this.buf.a[p++] = value >>> 24;
		} else {
			this.buf.a[p++] = value >>> 24;
			this.buf.a[p++] = value >> 16 & 255;
			this.buf.a[p++] = value >> 8 & 255;
			this.buf.a[p++] = value & 255;
		}
	}
	,setFloat32: function(byteOffset,value,littleEndian) {
		this.setUint32(byteOffset,haxe_io_FPHelper.floatToI32(value),littleEndian);
	}
	,setFloat64: function(byteOffset,value,littleEndian) {
		var i64 = haxe_io_FPHelper.doubleToI64(value);
		if(littleEndian) {
			this.setUint32(byteOffset,i64.low);
			this.setUint32(byteOffset,i64.high);
		} else {
			this.setUint32(byteOffset,i64.high);
			this.setUint32(byteOffset,i64.low);
		}
	}
	,__class__: js_html_compat_DataView
};
var js_html_compat_Uint8Array = function() { };
js_html_compat_Uint8Array.__name__ = true;
js_html_compat_Uint8Array._new = function(arg1,offset,length) {
	var arr;
	if(typeof(arg1) == "number") {
		arr = [];
		var _g = 0;
		while(_g < arg1) {
			var i = _g++;
			arr[i] = 0;
		}
		arr.byteLength = arr.length;
		arr.byteOffset = 0;
		arr.buffer = new js_html_compat_ArrayBuffer(arr);
	} else if(js_Boot.__instanceof(arg1,js_html_compat_ArrayBuffer)) {
		var buffer = arg1;
		if(offset == null) offset = 0;
		if(length == null) length = buffer.byteLength - offset;
		if(offset == 0) arr = buffer.a; else arr = buffer.a.slice(offset,offset + length);
		arr.byteLength = arr.length;
		arr.byteOffset = offset;
		arr.buffer = buffer;
	} else if((arg1 instanceof Array) && arg1.__enum__ == null) {
		arr = arg1.slice();
		arr.byteLength = arr.length;
		arr.byteOffset = 0;
		arr.buffer = new js_html_compat_ArrayBuffer(arr);
	} else throw new js__$Boot_HaxeError("TODO " + Std.string(arg1));
	arr.subarray = js_html_compat_Uint8Array._subarray;
	arr.set = js_html_compat_Uint8Array._set;
	return arr;
};
js_html_compat_Uint8Array._set = function(arg,offset) {
	var t = this;
	if(js_Boot.__instanceof(arg.buffer,js_html_compat_ArrayBuffer)) {
		var a = arg;
		if(arg.byteLength + offset > t.byteLength) throw new js__$Boot_HaxeError("set() outside of range");
		var _g1 = 0;
		var _g = arg.byteLength;
		while(_g1 < _g) {
			var i = _g1++;
			t[i + offset] = a[i];
		}
	} else if((arg instanceof Array) && arg.__enum__ == null) {
		var a1 = arg;
		if(a1.length + offset > t.byteLength) throw new js__$Boot_HaxeError("set() outside of range");
		var _g11 = 0;
		var _g2 = a1.length;
		while(_g11 < _g2) {
			var i1 = _g11++;
			t[i1 + offset] = a1[i1];
		}
	} else throw new js__$Boot_HaxeError("TODO");
};
js_html_compat_Uint8Array._subarray = function(start,end) {
	var t = this;
	var a = js_html_compat_Uint8Array._new(t.slice(start,end));
	a.byteOffset = start;
	return a;
};
var thx_Arrays = function() { };
thx_Arrays.__name__ = true;
thx_Arrays.contains = function(array,element,eq) {
	if(null == eq) return thx__$ReadonlyArray_ReadonlyArray_$Impl_$.indexOf(array,element) >= 0; else {
		var _g1 = 0;
		var _g = array.length;
		while(_g1 < _g) {
			var i = _g1++;
			if(eq(array[i],element)) return true;
		}
		return false;
	}
};
thx_Arrays.filterNull = function(a) {
	var arr = [];
	var $it0 = HxOverrides.iter(a);
	while( $it0.hasNext() ) {
		var v = $it0.next();
		if(null != v) arr.push(v);
	}
	return arr;
};
thx_Arrays.flatten = function(array) {
	return Array.prototype.concat.apply([],array);
};
thx_Arrays.groupByAppend = function(arr,resolver,map) {
	var _g1 = 0;
	var _g = arr.length;
	while(_g1 < _g) {
		var i = _g1++;
		var v = arr[i];
		var key = resolver(v);
		var acc = map.get(key);
		if(null == acc) map.set(key,[v]); else acc.push(v);
	}
	return map;
};
thx_Arrays.reduce = function(array,f,initial) {
	var $it0 = HxOverrides.iter(array);
	while( $it0.hasNext() ) {
		var v = $it0.next();
		initial = f(initial,v);
	}
	return initial;
};
thx_Arrays.reducei = function(array,f,initial) {
	var _g1 = 0;
	var _g = array.length;
	while(_g1 < _g) {
		var i = _g1++;
		initial = f(initial,array[i],i);
	}
	return initial;
};
var thx_Bools = function() { };
thx_Bools.__name__ = true;
thx_Bools.canParse = function(v) {
	var _g = v.toLowerCase();
	if(_g == null) return true; else switch(_g) {
	case "true":case "false":case "0":case "1":case "on":case "off":
		return true;
	default:
		return false;
	}
};
thx_Bools.parse = function(v) {
	var _g = v.toLowerCase();
	var v1 = _g;
	if(_g == null) return false; else switch(_g) {
	case "true":case "1":case "on":
		return true;
	case "false":case "0":case "off":
		return false;
	default:
		throw new js__$Boot_HaxeError("unable to parse \"" + v1 + "\"");
	}
};
var thx_Either = { __ename__ : true, __constructs__ : ["Left","Right"] };
thx_Either.Left = function(value) { var $x = ["Left",0,value]; $x.__enum__ = thx_Either; $x.toString = $estr; return $x; };
thx_Either.Right = function(value) { var $x = ["Right",1,value]; $x.__enum__ = thx_Either; $x.toString = $estr; return $x; };
var thx_Error = function(message,stack,pos) {
	Error.call(this,message);
	this.message = message;
	if(null == stack) {
		try {
			stack = haxe_CallStack.exceptionStack();
		} catch( e ) {
			haxe_CallStack.lastException = e;
			if (e instanceof js__$Boot_HaxeError) e = e.val;
			stack = [];
		}
		if(stack.length == 0) try {
			stack = haxe_CallStack.callStack();
		} catch( e1 ) {
			haxe_CallStack.lastException = e1;
			if (e1 instanceof js__$Boot_HaxeError) e1 = e1.val;
			stack = [];
		}
	}
	this.stackItems = stack;
	this.pos = pos;
};
thx_Error.__name__ = true;
thx_Error.__super__ = Error;
thx_Error.prototype = $extend(Error.prototype,{
	toString: function() {
		return this.message + "\nfrom: " + this.getPosition() + "\n\n" + this.stackToString();
	}
	,getPosition: function() {
		return this.pos.className + "." + this.pos.methodName + "() at " + this.pos.lineNumber;
	}
	,stackToString: function() {
		return haxe_CallStack.toString(this.stackItems);
	}
	,__class__: thx_Error
});
var thx_Functions = function() { };
thx_Functions.__name__ = true;
thx_Functions.equality = function(a,b) {
	return a == b;
};
var thx_Ints = function() { };
thx_Ints.__name__ = true;
thx_Ints.max = function(a,b) {
	if(a > b) return a; else return b;
};
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
var thx_Iterators = function() { };
thx_Iterators.__name__ = true;
thx_Iterators.map = function(it,f) {
	var acc = [];
	while( it.hasNext() ) {
		var v = it.next();
		acc.push(f(v));
	}
	return acc;
};
thx_Iterators.reduce = function(it,callback,initial) {
	var result = initial;
	while(it.hasNext()) result = callback(result,it.next());
	return result;
};
var thx_Maps = function() { };
thx_Maps.__name__ = true;
thx_Maps.tuples = function(map) {
	return thx_Iterators.map(map.keys(),function(key) {
		var _1 = map.get(key);
		return { _0 : key, _1 : _1};
	});
};
var thx_Objects = function() { };
thx_Objects.__name__ = true;
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
var thx__$ReadonlyArray_ReadonlyArray_$Impl_$ = {};
thx__$ReadonlyArray_ReadonlyArray_$Impl_$.__name__ = true;
thx__$ReadonlyArray_ReadonlyArray_$Impl_$.indexOf = function(this1,el,eq) {
	if(null == eq) eq = thx_Functions.equality;
	var _g1 = 0;
	var _g = this1.length;
	while(_g1 < _g) {
		var i = _g1++;
		if(eq(el,this1[i])) return i;
	}
	return -1;
};
if(Array.prototype.indexOf) HxOverrides.indexOf = function(a,o,i) {
	return Array.prototype.indexOf.call(a,o,i);
};
String.prototype.__class__ = String;
String.__name__ = true;
Array.__name__ = true;
var Int = { __name__ : ["Int"]};
var Dynamic = { __name__ : ["Dynamic"]};
var Float = Number;
Float.__name__ = ["Float"];
var Bool = Boolean;
Bool.__ename__ = ["Bool"];
var Class = { __name__ : ["Class"]};
var Enum = { };
if(Array.prototype.map == null) Array.prototype.map = function(f) {
	var a = [];
	var _g1 = 0;
	var _g = this.length;
	while(_g1 < _g) {
		var i = _g1++;
		a[i] = f(this[i]);
	}
	return a;
};
var __map_reserved = {}
var ArrayBuffer = $global.ArrayBuffer || js_html_compat_ArrayBuffer;
if(ArrayBuffer.prototype.slice == null) ArrayBuffer.prototype.slice = js_html_compat_ArrayBuffer.sliceImpl;
var DataView = $global.DataView || js_html_compat_DataView;
var Uint8Array = $global.Uint8Array || js_html_compat_Uint8Array._new;
dots_Attributes.properties = (function($this) {
	var $r;
	var _g = new haxe_ds_StringMap();
	_g.set("allowFullScreen",dots_AttributeType.BooleanAttribute);
	_g.set("async",dots_AttributeType.BooleanAttribute);
	_g.set("autoFocus",dots_AttributeType.BooleanAttribute);
	_g.set("autoPlay",dots_AttributeType.BooleanAttribute);
	_g.set("capture",dots_AttributeType.BooleanAttribute);
	_g.set("checked",dots_AttributeType.BooleanProperty);
	_g.set("cols",dots_AttributeType.PositiveNumericAttribute);
	_g.set("controls",dots_AttributeType.BooleanAttribute);
	_g.set("default",dots_AttributeType.BooleanAttribute);
	_g.set("defer",dots_AttributeType.BooleanAttribute);
	_g.set("disabled",dots_AttributeType.BooleanAttribute);
	_g.set("download",dots_AttributeType.OverloadedBooleanAttribute);
	_g.set("formNoValidate",dots_AttributeType.BooleanAttribute);
	_g.set("hidden",dots_AttributeType.BooleanAttribute);
	_g.set("loop",dots_AttributeType.BooleanAttribute);
	_g.set("multiple",dots_AttributeType.BooleanProperty);
	_g.set("muted",dots_AttributeType.BooleanProperty);
	_g.set("noValidate",dots_AttributeType.BooleanAttribute);
	_g.set("open",dots_AttributeType.BooleanAttribute);
	_g.set("readOnly",dots_AttributeType.BooleanAttribute);
	_g.set("required",dots_AttributeType.BooleanAttribute);
	_g.set("reversed",dots_AttributeType.BooleanAttribute);
	_g.set("rows",dots_AttributeType.PositiveNumericAttribute);
	_g.set("rowSpan",dots_AttributeType.NumericAttribute);
	_g.set("scoped",dots_AttributeType.BooleanAttribute);
	_g.set("seamless",dots_AttributeType.BooleanAttribute);
	_g.set("selected",dots_AttributeType.BooleanProperty);
	_g.set("size",dots_AttributeType.PositiveNumericAttribute);
	_g.set("span",dots_AttributeType.PositiveNumericAttribute);
	_g.set("start",dots_AttributeType.NumericAttribute);
	_g.set("value",dots_AttributeType.SideEffectProperty);
	_g.set("itemScope",dots_AttributeType.BooleanAttribute);
	$r = _g;
	return $r;
}(this));
haxe_io_FPHelper.i64tmp = (function($this) {
	var $r;
	var x = new haxe__$Int64__$_$_$Int64(0,0);
	$r = x;
	return $r;
}(this));
js_Boot.__toStr = {}.toString;
js_html_compat_Uint8Array.BYTES_PER_ELEMENT = 1;
Main.main();
})(typeof console != "undefined" ? console : {log:function(){}}, typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this);

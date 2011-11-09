(function() {
  var console, module, top;
  top = (typeof exports !== "undefined" && exports !== null ? exports : void 0) || window;
  top.top = top;
  module = function(name, module_fn) {
    var item, ns, _i, _len, _ref;
    ns = top;
    _ref = name.split('.');
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      item = _ref[_i];
      ns = ns[item] || (ns[item] = {});
    }
    return module_fn(ns);
  };
  top.module = module;
  if (typeof console === "undefined" || console === null) {
    console = {
      log: (function() {}),
      warn: (function() {})
    };
  }
}).call(this);

(function() {
  var module, top, _base;
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
  (_base = top.document).head || (_base.head = document.getElementsByTagName('head')[0]);
  if (typeof console === "undefined" || console === null) {
    top.console = {
      log: (function() {}),
      warn: (function() {})
    };
  }
}).call(this);

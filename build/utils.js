(function() {
  var module, _base;

  module = function(name, module_fn) {
    var item, ns, top, _i, _len, _ref;
    top = (typeof exports !== "undefined" && exports !== null ? exports : void 0) || window;
    ns = top;
    _ref = name.split('.');
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      item = _ref[_i];
      ns = ns[item] || (ns[item] = {});
    }
    return module_fn(ns);
  };

  window.module = module;

  (_base = window.document).head || (_base.head = document.getElementsByTagName('head')[0]);

  if (typeof console === "undefined" || console === null) {
    window.console = {
      log: (function() {}),
      warn: (function() {})
    };
  }

}).call(this);

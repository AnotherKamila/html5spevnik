(function() {
  var top;
  var __slice = Array.prototype.slice;

  top = typeof exports !== "undefined" && exports !== null ? exports : this;

  top.top = top;

  top.log = function() {
    var args;
    args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
    return console.log.apply(console, args);
  };

  top.err = function() {
    var args;
    args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
    args.unshift('ERR:');
    return console.warn.apply(console, args);
  };

  window.console || (window.console = {
    log: (function() {}),
    warn: (function() {})
  });

}).call(this);

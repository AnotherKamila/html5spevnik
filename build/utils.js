(function() {
  var top, _base;

  top = typeof exports !== "undefined" && exports !== null ? exports : window;

  top.top = top;

  (_base = window.document).head || (_base.head = document.getElementsByTagName('head')[0]);

  if (typeof console === "undefined" || console === null) {
    window.console = {
      log: (function() {}),
      warn: (function() {})
    };
  }

}).call(this);

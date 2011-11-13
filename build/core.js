(function() {
  module('S', function(exports) {
    var debug, doEvent, fireDoneEvent;
    exports.version = '0.0';
    debug = true;
    exports.onEvent = function(type, callback) {
      return document.addEventListener(type, callback);
    };
    exports.fireEvent = function(type, data) {
      var e;
      if (debug) {
        console.log("Events: `" + type + "' has fired");
      }
      window.addEventListener(type, fireDoneEvent);
      return e = doEvent(type, data);
    };
    fireDoneEvent = function(e) {
      if (debug) {
        console.log("Events: `" + e.type + "' done processing");
      }
      window.removeEventListener(e.type, fireDoneEvent, false);
      return doEvent(e.type + ':done', e.data);
    };
    return doEvent = function(type, data) {
      var e;
      e = document.createEvent('Events');
      e.initEvent(type, true, true);
      e.data = data;
      return document.dispatchEvent(e);
    };
  });
}).call(this);

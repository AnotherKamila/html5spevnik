(function() {
  module('Spevnik', function(exports) {
    var debug;
    exports.version = '0.0.1';
    debug = true;
    exports.onEvent = function(eventName, callback) {
      return window.addEvent(eventName, callback);
    };
    return exports.fireEvent = function(eventName, eventObj) {
      if (debug) {
        console.log("Events: " + eventName + " has fired.");
      }
      return window.fireEvent(eventName, eventObj);
    };
  });
}).call(this);

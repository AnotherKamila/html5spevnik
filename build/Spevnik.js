(function() {
  var Spevnik;
  Spevnik = {
    version: '0.0.1',
    debug: true,
    onEvent: function(eventName, callback) {
      if (this.debug) {
        console.log("Events: Adding event listener to `" + eventName + "'");
      }
      return window.addEvent(eventName, callback);
    },
    fireEvent: function(eventName, eventObj) {
      if (this.debug) {
        console.log("Events: " + eventName + " has fired.");
      }
      return window.fireEvent(eventName, eventObj);
    },
    init: function() {
      return this.Loader.init();
    }
  };
  window.Spevnik = Spevnik;
  window.addEvent('domready', function() {
    return Spevnik.init();
  });
}).call(this);

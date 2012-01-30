(function() {
  var S;

  S = top.S = {};

  (function() {
    var components, debug;
    S.version = '0.0';
    debug = true;
    components = {};
    S.register = function(name, component_fn) {
      if (debug) console.log("Registering component: " + name);
      components[name] = {
        __name__: name
      };
      return component_fn(components[name]);
    };
    return S.run = function(hookname, data) {
      var c, i, _results;
      if (debug) console.log("Running hook: " + hookname);
      for (i in components) {
        c = components[i];
        if (!(c[hookname] != null)) continue;
        if (debug) console.log("    * on " + i);
        c[hookname](data);
      }
      _results = [];
      for (i in components) {
        c = components[i];
        if (!(c[hookname + ':done'] != null)) continue;
        if (debug) console.log("    = running :done on " + i);
        _results.push(c[hookname + ':done'](data));
      }
      return _results;
    };
  })();

}).call(this);

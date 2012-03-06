(function() {
  var S;
  var __slice = Array.prototype.slice;

  S = top.S = {};

  (function() {
    var hooks, services;
    S.version = '0.0';
    S.debug = true;
    S.DBG = {};
    hooks = {};
    services = {};
    top.module = function(name, desc, module_fn) {
      var m;
      m = {
        name: name,
        desc: desc
      };
      module_fn(m);
      return S.say('ModuleAdded', m);
    };
    S.say = function() {
      var args, f, hookname, _i, _len, _ref;
      hookname = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      if (S.debug) log("H :: Running: " + hookname);
      if (hooks[hookname] != null) {
        _ref = hooks[hookname];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          f = _ref[_i];
          f.apply(null, args);
        }
      }
      if (!hookname.match(/:done$/)) return S.say(hookname + ':done');
    };
    S.hookto = function(name, fn) {
      var _ref;
      if (S.debug) log("H :: Registered " + name);
      if ((_ref = hooks[name]) == null) hooks[name] = [];
      return hooks[name].push(fn);
    };
    S.ask = function(interface) {
      if (!(services[interface] != null)) {
        throw new Error("Service not implemented: " + interface + " does not exist");
      }
      if (S.debug) log("S :: Asked for: " + interface);
      return services[interface];
    };
    return S.provide = function(interface, obj) {
      if (services[interface] != null) {
        throw new Error("Service conflict: Service " + interface + " provided more than once");
      }
      if (S.debug) log("S :: Added " + interface);
      return services[interface] = obj;
    };
  })();

}).call(this);

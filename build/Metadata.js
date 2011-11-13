(function() {
  module('S.Metadata', function(exports) {
    var debug, submodules;
    debug = true;
    submodules = {};
    exports.register = function(subm) {
      return submodules[subm.name] = subm;
    };
    return S.onEvent('allModulesLoaded', function() {
      return S.onEvent('DB.beforeSetup', function(e) {
        var name;
        return e.data.addIndexFields((function() {
          var _results;
          _results = [];
          for (name in submodules) {
            _results.push(name);
          }
          return _results;
        })());
      });
    });
  });
}).call(this);

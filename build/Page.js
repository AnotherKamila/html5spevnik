
  module('Page', 'the root widget, handles different app modes', function() {
    var content;
    content = new Element('div#content');
    window.on({
      domready: function() {
        return document.body.empty().grab(content);
      }
    });
    window.on({
      hashchange: function(hash) {
        var mode;
        mode = hash.slice(0, hash.indexOf('/'));
        if (S.debug) return log("Page: hashchange --> switching mode to " + mode);
      }
    });
    return S.hookto('allModulesLoaded', function() {
      return window.fireEvent('hashchange', location.hash.charAt(0 === '#') ? location.hash.substr(1) : location.hash);
    });
  });


  module('Page', 'the root widget, handles different app modes', function() {
    var content, modeswitch;
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
        return modeswitch(mode !== '' ? mode : 'empty');
      }
    });
    S.hookto('allModulesLoaded', function() {
      return window.onhashchange();
    });
    return modeswitch = function(mode) {
      var err, handler;
      if (S.debug) log("Page: hashchange --> switching mode to " + mode);
      try {
        return handler = S.ask("appMode." + mode);
      } catch (mode_err) {
        err = {
          title: function() {
            return 'Invalid URL';
          },
          html: function() {
            return 'No way to handle the current URL.';
          },
          render: function(c) {
            return c.set('html', err.html());
          }
        };
        try {
          handler = S.ask('appMode.error');
          return handler.error = err;
        } catch (err_err) {
          return handler = err;
        }
      } finally {
        document.title = handler.title() + (" | spevnik v" + S.version);
        content.empty();
        handler.render(content);
        if (S.debug) log('Page: mode switch done');
      }
    };
  });


  module('ErrorPage', 'displays error pages with the given message', function() {
    return S.provide('appMode.error', {
      error: {
        title: function() {
          return 'Oops, Error';
        },
        html: function() {
          return ':-(';
        }
      },
      title: function() {
        return S.ask('appMode.error').error.title();
      },
      render: function(c) {
        return c.grab(new Element('p', {
          html: S.ask('appMode.error').error.html()
        }));
      }
    });
  });

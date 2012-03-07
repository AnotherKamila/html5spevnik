
  module('ErrorPage', 'displays error pages with the given message', function() {
    return S.provide('appMode.error', {
      error: {
        title: 'Oops, Error',
        html: ':-('
      },
      title: function() {
        return S.ask('appMode.error').error.title();
      },
      html: function() {
        return new Element('p', {
          html: S.ask('appMode.error').error.html()
        });
      }
    });
  });

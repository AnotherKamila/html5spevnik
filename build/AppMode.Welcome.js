
  module('WelcomePage', 'shows a welcome page when there is no URL fragment', function() {
    return S.provide('appMode.empty', {
      html: function() {
        return new Element('p', {
          text: 'Hello World!'
        });
      },
      title: function() {
        return 'Welcome';
      }
    });
  });


  module('WelcomePage', 'shows a welcome page when there is no URL fragment', function() {
    return S.provide('appMode.empty', {
      title: function() {
        return 'Welcome';
      },
      render: function(container) {
        return container.grab(new Element('p', {
          text: 'Hello World!'
        }));
      }
    });
  });

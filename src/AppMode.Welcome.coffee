module 'WelcomePage', 'shows a welcome page when there is no URL fragment', ->

    S.provide 'appMode.empty',
            title: -> 'Welcome'
            render: (container) -> container.grab new Element 'p', text: 'Hello World!'

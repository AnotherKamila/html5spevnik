module 'WelcomePage', 'shows a welcome page when there is no URL fragment', ->

    S.provide 'appMode.empty',
            html: -> new Element 'p', text: 'Hello World!'
            title: -> 'Welcome'

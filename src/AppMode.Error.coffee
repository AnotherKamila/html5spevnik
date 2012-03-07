module 'ErrorPage', 'displays error pages with the given message', ->

    S.provide 'appMode.error',
            error:
                title: -> 'Oops, Error'
                html:  -> ':-('

            title: -> S.ask('appMode.error').error.title()
            render: (c) -> c.grab new Element 'p', html: S.ask('appMode.error').error.html()

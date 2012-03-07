module 'Page', 'the root widget, handles different app modes', ->
    
    content = new Element 'div#content'
    window.on domready: ->
        document.body.empty().grab content

    # init
    window.on hashchange: (hash) ->
        mode = hash.slice 0, hash.indexOf '/'
        modeswitch if mode != '' then mode else 'empty'

    S.hookto 'allModulesLoaded', -> window.onhashchange()

    modeswitch = (mode) ->
        log "Page: hashchange --> switching mode to #{mode}" if S.debug
        try
            handler = S.ask "appMode.#{mode}"
        catch mode_err
            err = 
                title: -> 'Invalid URL'
                html: -> 'No way to handle the current URL.'
                render: (c) -> c.set 'html', err.html()
            try
                handler = S.ask 'appMode.error'
                handler.error = err
            catch err_err
                handler = err
        finally
            document.title = handler.title() + " | spevnik v#{S.version}"
            content.empty()
            handler.render content
            log 'Page: mode switch done' if S.debug

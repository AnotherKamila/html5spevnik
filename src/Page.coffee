module 'Page', 'the root widget, handles different app modes', ->
    
    content = new Element 'div#content'
    window.on domready: -> document.body.empty().grab content

    # init
    window.on hashchange: (hash) ->
        mode = hash.slice 0, hash.indexOf '/'
        log "Page: hashchange --> switching mode to #{mode}" if S.debug
#       TODO
#       for i of services 'appMode'
#           if i.handles location.hash # zjavne idem dufat ze matchuje iba jedna, inak posledne vyhra (chcelo by to specifickejsie overridnu genericke, mozno nevracia bool ale prioritu, ale blee)
#               content = i.html.replaces content; document.title = i.title + " | spevnik v#{S.version}"

        # TODO chcem nejake ze ak na tuto url neni handler tak error? lebo ak
        # neni genericky * error handler lebo neni precedence tak to treba tuto
        # spravit explicitne (a fuj)

    S.hookto 'allModulesLoaded', -> window.fireEvent 'hashchange',
        if location.hash.charAt 0 == '#' then location.hash.substr 1 else location.hash

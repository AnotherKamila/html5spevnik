# This module is responsible for handling the database. All transactions are
# defined here.

# Structure
# ---------
#
# Each object in the object store has a set of metadata properties, which are
# indexed. (If a metadata property does not exist on an object, the object can
# still be added to the database, but is invisible to that index.) Then there is
# the `data` property, which is an object. It is not indexed. Inside `data`
# there are fields for each data submodule (e.g. a submodule named `text` has
# access to (only) `data['text']`). The insides of `data` are completely
# uninteresting for `DB`.

module 'S.DB', (exports) ->
    debug = true

    # Holds a reference to the database.
    db = null

    # All modules that want to add metadata indices to the database need to use
    # this method. It is made available to them inside the `data` property for
    # the `DB.beforeSetup` event.
    #
    # Pass an array of strings -- the future index names.
    addIndexFields = (arr) => indices[item] = true for item in arr

    # Holds the future indices for the DB. This object is populated by the
    # `addIndexFields` method. 
    indices = {}

    # This function is run after all modules have finished loading (and
    # registering their indices).
    init = ->
        console.log 'DB: Initialization started' if debug
        window.indexedDB or= webkitIndexedDB or mozIndexedDB or moz_indexedDB

        # Open or create the database
        openReq = indexedDB.open 'spevnik', 'database for my pretty songbook'
        openReq.onerror = (e) -> console.warn 'ERR: DB: Cannot open DB: ' + e

        openReq.onsuccess = (e) =>
            # store the handle to the DB
            db = e.target.result
            # events bubble, so this is my generic DB error handler (for now)
            db.onerror = (e) -> console.warn 'ERR: DB: ' + e

            # `db.version` is a description of what the database looks like
            # (i.e. what indices there are). In case this does not match (either
            # because version has never been set, or because new modules have
            # been added), we need to change the indices and update the version.
            console.log "DB: Current version: #{db.version}" if debug
            console.log "DB: Should be: #{getExpectedVersion()}" if debug
            if db.version != getExpectedVersion()
                setVReq = db.setVersion getExpectedVersion()
                setVReq.onsuccess = setupDB
            else
                # let the world know the DB is ready
                S.fireEvent 'DB.ready'

    # Creates the necessary indices in a `setVersion` request
    setupDB = (e) ->
        unless db.objectStoreNames.contains('songs')
            console.log 'Creating object store...'
            store = db.createObjectStore 'songs',
                        { keyPath: 'id', autoIncrement: true }

        for index of indices
            console.log "DB: Creating index for #{index}" if debug
            # name and key path will be the same
            #
            # TODO maybe specifying the options object should be possible
            store.createIndex index, index, { unique: false }

        # we're done
        S.fireEvent 'DB.ready'

    # Generates the DB version based on the Spevnik version and active indices
    getExpectedVersion = -> S.version+'|'+ ( i for i of indices ).join ','

    S.onEvent 'DB.beforeSetup:done', init

    # once all modules are loaded, we can start emitting events
    #
    # **Important**: All modules are required to only start emitting events
    # here. This might be automatized at some point. Or it might not.
    S.onEvent 'allModulesLoaded', ->

        # I want to initialize the DB
        S.fireEvent 'DB.beforeSetup', { addIndexFields: addIndexFields }

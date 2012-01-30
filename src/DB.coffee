# This module is responsible for handling the database. All transactions are
# defined here.
#
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

S.register 'DB', (hooks) ->
    debug = true

    db = null

    hooks['init'] = ->
        # let the outside world tell us what they want in the DB
        S.run 'DB.beforeSetup', { addIndexField: addIndexField }

    # Initializes the DB
    hooks['DB.beforeSetup:done'] = ->
        console.log 'DB: Initialization started' if debug
        window.indexedDB or= webkitIndexedDB or mozIndexedDB or moz_indexedDB # TODO maybe make a separate file for stuff like this

        openReq = indexedDB.open 'spevnik', 'database for my pretty songbook'
        openReq.onerror = (e) -> console.warn 'ERR: DB: Cannot open DB: ' + e

        openReq.onsuccess = (e) ->
            # store the handle to the DB
            db = e.target.result
            # DB events bubble, so this is my generic DB error handler (for now)
            db.onerror = (e) -> console.warn 'ERR: DB: ' + e

            # `db.version` is a description of what the database looks like
            # (i.e. what indices there are). In case this does not match (either
            # because version has never been set, or because new modules have
            # been added), we need to change the indices and update the version.
            console.log "DB: Current version: #{db.version}" if debug
            console.log "DB: Should be:       #{getExpectedVersion()}" if debug

            # adds necessary indices on setVersion
            if db.version != getExpectedVersion()
                console.log 'DB: initiating setVersion request...'
                setVReq = db.setVersion getExpectedVersion()
                setVReq.onsuccess = (e) -> # Creates the necessary indices in a `setVersion` request
                    # if the store exists, just get a handle, otherwise create it
                    if db.objectStoreNames.contains 'songs'
                        store = e.target.transaction.objectStore 'songs'
                    else
                        console.log 'DB: Creating object store...' if debug
                        store = db.createObjectStore 'songs',
                                    { keyPath: 'id', autoIncrement: true }

                    for index of indices
                        console.log "DB: Creating index for #{index}" if debug
                        # name and key path will be the same  
                        # (TODO maybe specifying the options object should be possible)
                        store.createIndex index, index, { unique: false } # TODO what happens if it already exists?

                    # we're done
                    #
                    # (TODO if I see funny bugs, it might be because `createIndex` might be
                    # async actually)
                    S.run 'DB.ready'
            else
                # otherwise we are done
                S.run 'DB.ready'

    # ### addIndexFields (semi-public method) ###
    #
    # All modules that want to add metadata indices to the database need to use
    # this method. It is made available to them inside the `data` object for
    # the `DB.beforeSetup` event.
    #
    # Pass a string: the future index name.
    addIndexField = (f) -> indices[f] = true

    # The `indices` object holds the future indices for the DB. It is populated
    # by the `addIndexFields` method. 
    indices = {}

    # ### getExpectedVersion (private helper) ###
    #
    # Generates the DB version based on the Spevnik version and active indices
    getExpectedVersion = -> S.version+'|'+ ( i for i of indices ).join ','

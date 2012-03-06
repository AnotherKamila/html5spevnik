# This component is responsible for handling the database. All transactions are
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

module 'DB', 'database interface on top of IndexedDB', ->
    debug = true

    db = null

    S.hookto 'allModulesLoaded', ->
        # let the outside world tell us what they want in the DB
        S.say 'DB.beforeSetup'

    # holds the future indices for the DB; only the keys are important
    indices = S.Metadata

    # Initializes the DB
    S.hookto 'DB.beforeSetup:done', ->
        log 'DB: Starting initialization'

        openReq = indexedDB.open 'spevnik', 'database for my pretty songbook'

        openReq.onerror = (e) -> err 'DB: Cannot open DB:', e

        openReq.onsuccess = (e) ->
            # store the handle to the DB
            db = e.target.result
            # DB events bubble, so this is my generic DB error handler (for now)
            db.onerror = (e) -> err 'DB: ', e

            # `db.version` is a description of what the database looks like
            # (i.e. what indices there are). In case this does not match (either
            # because version has never been set, or because new modules have
            # been added), we need to change the indices and update the version.
            log "DB: Current version: #{db.version}" if debug
            log "DB: Should be:       #{getExpectedVersion()}" if debug

            # adds necessary indices on setVersion
            if db.version == getExpectedVersion()
                S.say 'DB.ready'
            else
                log 'DB: initiating setVersion request...'
                setVReq = db.setVersion getExpectedVersion()
                setVReq.onsuccess = (e) ->
                    # if the store exists, just get a handle, otherwise create it
                    if db.objectStoreNames.contains 'songs'
                        store = e.target.transaction.objectStore 'songs'
                    else
                        log 'DB: Creating object store...' if debug
                        store = db.createObjectStore 'songs',
                                    { keyPath: 'id', autoIncrement: true }

                    for index of indices
                        log "DB: Creating index for #{index}" if debug
                        # name and key path will be the same  
                        # (TODO maybe specifying the options object should be possible)
                        store.createIndex index, index, { unique: false } # TODO what happens if it already exists?

                    # we're done
                    S.say 'DB.ready'

    # Generates the DB version based on the Spevnik version and active indices
    getExpectedVersion = -> S.version+'|'+ ( i for i of indices ).join ','

# Provides the interface for metadata submodules.

module 'S.Metadata', (exports) ->
    debug = true

    # store all the loaded submodules here
    submodules = {}

    # ### register (public method) ###
    #
    # Metadata submodules need to use this function to register. Pass an object.
    # It needs to contain:
    #
    # - `name`: the short name of the plugin
    # - `friendlyName`: what will be displayed in the UI (optional,
    #    `name.capitalize()` will be used if not provided)
    # - `toHtml`: function used to transform the value into its HTML
    #    representation (so for title this would just return the string, for
    #    rating the appropriate # of stars etc.)
    # - `priority`: number, higher numbers are closer to the left edge in the UI
    #   (optional, if missing they will be sorted alphabetically after the ones
    #   with priority specified)
    exports.register = (subm) ->
        submodules[subm.name] = subm

    S.onEvent 'allModulesLoaded', ->
        # tell the DB what indices are needed
        S.onEvent 'DB.beforeSetup', (e) ->
            e.data.addIndexFields ( name for name of submodules )

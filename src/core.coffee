# *Provides the definition of `module` and the hooks and services implementation

# *Note about terminology*: A component is a logical set of services (e.g. the
# database or the title metadata stuff), while a module is a chunk of code (such
# as a specific DB implementation or all basic metadata). Modules will at some
# point be user-selectable.

# Hooks- and Services-based architecture
# --------------------------------------
#
# There are two ways to pass messages between various components:
#
# - **services** -- I want you to do this (like public methods -- a specific
#   request to do something and possibly return a value), and
# - **hooks** -- just FYI (aka announces -- just saying what happened, but not
#   caring what the others will do).
#
# **Modules are supposed to only care about themselves**, i.e. there is no
# direct way to access a different module -- one can only ask for a service, and
# knows nothing about the specific provider.

S = top.S = {}
do ->
    S.version = '0.0'
    S.debug = true
    S.DBG = {}

    hooks = {}
    services = {}

    # A module is a closure (i.e. a function). This function executes the module
    # module if it is enabled, and collects the names and descriptions
    # of all available modules so that the user can choose from them. It also
    # provides a way for modules to export things to their namespace (but this
    # should be used only for debugging). The exports object also contains the
    # module info, so that it can be easily referenced inside the module.
    #
    # TODO This function will eventually check whether a module is enabled before it
    # runs the function
    # TODO something somewhere really should catch the conflict exception!
    # 
    # TODO fix the docs once we have the stuff
    #
    # here come the docs from the previous version:
    # The hook callbacks will be called with one argument: the data supplied by
    # the sender, if any.
    # 
    # A hook name can also have the form "something:done". This will be run once
    # all hooks on "something" have finished executing -- therefore you can wait
    # for other modules to respond to something and then resume.
    #
    # (Note: "something:done:done" etc will not be supported, that really
    # shouldn't be necessary.)
    top.module = (name, desc, module_fn) -> 
        m = name: name, desc: desc
        module_fn m
        S.say 'ModuleAdded', m

    # Runs a specified hook (passing all but the 1st argument to all registered
    # functions).
    S.say = (hookname, args...) ->
        log "H :: Running: #{hookname}" if S.debug
        if hooks[hookname]? then f.apply null, args for f in hooks[hookname]
        # we explicitly don't want to support this recursively
        S.say hookname + ':done' unless hookname.match /:done$/

    # Registers a function to execute when a specific hook is run
    S.hookto = (name, fn) ->
        log "H :: Registered #{name}" if S.debug
        hooks[name] ?= []
        hooks[name].push fn

    # Asks for a service. This function returns whatever the service returns; it
    # is synchronous.
    S.ask = (interface) ->
        if not services[interface]? then throw new Error "Service not implemented: #{interface} does not exist"
        log "S :: Asked for: #{interface}" if S.debug
        return services[interface]

    S.provide = (interface, impl) ->
        if services[interface]? then throw new Error "Service conflict: Service #{interface} provided more than once"
        log "S :: Added #{interface}" if S.debug
        services[interface] = impl

# *Provides Spevnik's interface for registering hooks.*
#
# Hooks/Events-based architecture
# -------------------------------
#
# All message passing between separate components will be done using the
# following methods for running hooks.
#
# A component is some private stuff and a collection of responses to
# events/hooks. 
#
# **Components are supposed to only care about themselves**, i.e. I just tell
# the world what I want to do, maybe someone will say something, maybe not, that
# is their problem. (This will hopefully make it extremely easy to add new
# components.)

#
log '=== Pre-initialization started ==='

S = top.S = {}
do () ->
    S.version = '0.0'

    debug = true

    components = {}

    # Allows components to register hooks. Executing a hook is the only way a
    # component can be told to do something. Hooks are responses to events.
    #
    # The hook callbacks will be called with one argument: the data supplied by
    # the sender, if any.
    # 
    # A hook name can also have the form "something:done". This will be run once
    # all hooks on "something" have finished executing -- therefore you can wait
    # for other modules to respond to something and then resume.
    #
    # (Note: "something:done:done" etc will not be supported, that really
    # shouldn't be necessary.)
    S.register = (name, component_fn) ->
        log "Registering component: #{name}" if debug
        components[name] = { __name__: name }
        component_fn components[name]

    # Runs a specified hook (optionally passing some event data as the 2nd
    # argument). This causes all exported methods with name "`hookname`" of all
    # registered components to be run.
    S.run = (hookname, data) ->
        log "Running hook: #{hookname}" if debug
        for i,c of components when c[hookname]?
            log "  - on #{i}" if debug
            c[hookname] data
        # we explicitly don't want to support this recursively
        for i,c of components when c[hookname + ':done']?
            console.log "  * running :done on #{i}" if debug
            c[hookname + ':done'] data


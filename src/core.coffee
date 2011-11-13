# The really core stuff is defined here.
#
# Provides Spevnik's event methods.

module 'S', (exports) ->
    exports.version = '0.0'

    debug = true

    # Event-based architecture
    # ------------------------
    #
    # All message passing between modules will be done using the following
    # methods for firing events and attaching event listeners.
    #
    # **Modules are supposed to only care about themselves**, i.e. I just tell
    # the world what I want to do, maybe someone will say something, maybe not,
    # that is their problem.

    # ### onEvent (public method) ###
    # 
    # Use this to attach event handlers to events. The callback will get a
    # single argument: the event object. It has a `data` property which contains
    # the object that the sender supplied, if any.
    #
    # You can also attach to `someEvent:done`; this is fired once all processing
    # has finished on `someEvent`. (Example usage: You want other modules to
    # have their say, so you need to wait until they have finished talking and
    # then resume.)
    #
    # If the event sender needs other modules to react, it provides a method to
    # do so inside the `data` property of the event object. (Example: see how `DB`
    # allows modules to add indices.)
    exports.onEvent = (type, callback) ->
        # I am using the `document` and native event handling here rather than
        # creating a custom object and extending it with Mootools Events. The
        # reason is that I need event bubbling, see `fireEvent` below.
        document.addEventListener type, callback

    # ### fireEvent (public method) ###
    #
    # Use this to fire events that other modules can bind to. This is the
    # preferred way to pass messages between modules. Any relevant data attached
    # to that event should be passed as the second parameter. It will be
    # available inside the resulting event object's `data` property.
    exports.fireEvent = (type, data) ->
        console.log "Events: `#{type}' has fired" if debug

        # Due to the nature of event bubbling, the event will get to `window`
        # only after all listeners on `document` have been fired (and finished
        # executing, since JS is singlethreaded). Therefore once the event (and
        # control) gets here, we know all processing has finished and we can
        # tell the world about it.
        window.addEventListener type, fireDoneEvent

        # now that the done listener is in place, the event can be fired
        e = doEvent type, data

    # ### fireDoneEvent (private helper function) ###
    fireDoneEvent = (e) ->
        console.log "Events: `#{e.type}' done processing" if debug

        # remove this listener, it will be re-added if needed (we don't want
        # two)
        window.removeEventListener e.type, fireDoneEvent, false

        doEvent e.type + ':done', e.data

    # ### doEvent (helper) ###
    #
    # Takes the event name and data and fires the event.
    doEvent = (type, data) ->
        # the events need to look like events in order to bubble, so we make
        # real events instead of a custom object
        e = document.createEvent 'Events'
        e.initEvent type, true, true

        # add the famous `data` property
        e.data = data

        # and finally throw it
        document.dispatchEvent e

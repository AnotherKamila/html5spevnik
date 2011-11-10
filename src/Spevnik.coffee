# The really core stuff is defined here.
#
# Provides Spevnik's event methods.

module 'Spevnik', (exports) ->
    exports.version = '0.0.1'

    debug = true

    # We will have an event-based architecture. The core core core part is
    # basically just this fact. Here I define the methods for firing events and
    # attaching event handlers. All message-passing between modules will be done
    # using these.

    # Use this to attach event handlers to events. The callback will get a
    # single argument: the event object. It has a `data` property which contains
    # (a copy of) the object that the sender supplied, if any.
    #
    # You can also attach to `someEvent:done`; this is fired once all processing
    # has finished on `someEvent`. (Example usage: You want other modules to
    # have their say, so you need to wait until they have finished talking and
    # then resume.)
    #
    # TODO how to alter the data on event (probably: there is a method (like
    # `alter`) provided by the sender inside the data object, and the sender
    # manages what the others say to `alter`)
    # 
    # **Modules are supposed to be egocentric bastards that only care about
    # themselves**
    exports.onEvent = (type, callback) ->
        # I am using the `document` object here rather than creating a custom one
        # and extending it with Mootools `Events`. The reason is that I need event
        # bubbling, see `fireEvent`
        document.addEventListener type, callback

    # Use this to fire events that other modules can bind to. This is the
    # preferred way to pass messages between modules. Any relevant data attached
    # to that event should be passed as the second parameter.
    exports.fireEvent = (type, data) ->
        console.log "Events: `#{type}' has fired" if debug

        # Due to the nature of event bubbling, the event will get to `window`
        # only after all listeners on `document` have been fired (and finished
        # executing since JS is singlethreaded). Therefore once the event (and
        # control) gets here, we know all processing has finished and we can
        # tell the world about it.
        window.addEventListener type, fireDoneEvent

        # now that the done listener is in place, the event can be fired
        e = doEvent type, Object.clone data

    fireDoneEvent = (e) ->
        console.log "Events: `#{e.type}' done processing" if debug

        # remove this listener, we're done here
        window.removeEventListener e.type, fireDoneEvent, false

        # fire :done event
        doEvent e.type + ':done', e.data

    # Takes the event name and data and fires the event.
    doEvent = (type, data) ->
        # Uses the DOM2 API (MooTools does some weird stuff behind the scenes)

        # the events need to look like events in order to bubble
        e = document.createEvent 'Events'
        e.initEvent type, true, true

        e.data = data

        # and finally throw it
        document.dispatchEvent e

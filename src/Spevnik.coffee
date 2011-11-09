# The really core stuff is defined here.
#
# Provides Spevnik's event methods.

module 'Spevnik', (exports) ->
    exports.version = '0.0.1'

    debug = true

    # We will have an event-based architecture. The core core core part is
    # basically just this fact. Here I define the methods for firing events and
    # attaching event handlers. All message-passing between modules will be done
    # using these (probably).

    # Use this to attach event handlers to events. The callback will get a
    # single argument: the event object that the sender supplied, if any.
    #
    # For now only literal event names are supported, but regex support might be
    # added if the need arises (i.e. I have a very rough idea of how to do it,
    # but I am too lazy).
    exports.onEvent = (eventName, callback) ->
        # I am using the `window` object here rather than creating a custom one
        # and extending it with Mootools Events. The reason is simply that I do
        # not know of any drawbacks of doing this.
        window.addEvent eventName, callback

    # Use this to fire events that other modules can bind to. This is the
    # preferred way to pass messages between modules. Any relevant data attached
    # to that event should be passed as the second parameter.
    #
    # Event names should follow the `'eventcategory.eventtype'` or possibly
    # `'module.eventtype'` convention wherever it makes sense.
    exports.fireEvent = (eventName, eventObj) ->
        console.log "Events: #{eventName} has fired." if debug
        window.fireEvent eventName, eventObj

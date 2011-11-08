# The really core stuff is defined here.

Spevnik =
    # almost global almost constants
    version: '0.0.1'
    debug: true

    # We will have an event-based architecture. The core core core part is
    # basically just this fact. Here I define the methods for firing events and
    # attaching event handlers. All message-passing between modules will be done
    # using these (probably).

    # Use this to attach event handlers to events. The callback will get a
    # single argument: the event object that the sender supplied, if any.
    #
    # For now only literal event names are supported, but regex support might be
    # added if the need arises.
    onEvent: (eventName, callback) ->
        console.log "Events: Adding event listener to `#{eventName}'" if @debug

        # I am using the `window` object here rather than creating a custom one
        # and extending it with Mootools Events. The reason is simply that I do
        # not know of any drawbacks of doing this.
        window.addEvent eventName, callback

    # Use this to fire events that other modules can bind to. This is the only
    # cool way to pass messages between modules. Any relevant data attached to
    # that event should be passed inside the `eventObj` object.
    #
    # Event names should follow the 'eventcategory.eventtype' convention
    # wherever it makes sense.
    fireEvent: (eventName, eventObj) ->
        console.log "Events: #{eventName} has fired." if @debug
        window.fireEvent eventName, eventObj

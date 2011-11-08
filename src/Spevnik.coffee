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

    # Initializing is handled by the `Loader` module. Here we just alias its
    # `init` method. I am not using the events system, since (1) it does not
    # really make sense here, and (2) the order of execution is important at
    # this stage, so I am explicitly declaring it all in one place instead.
    #
    # Maybe not using events is not that great, because of hereby introduced
    # coupling between `Loader` and other modules (and actually between this
    # file and `Loader`, too, which is sad because `Loader` does not exist yet).
    # TODO rethink this
    init: ->
        # We assume that `Loader` and `Loader.init` exist. It cannot be checked
        # here, since they are not loaded at this point.
        @Loader.init()

# Attach Spevnik to `window`. The modules will reference this directly.
window.Spevnik = Spevnik

# Initialize me as soon as possible, but no sooner.
window.addEvent 'domready', ->
    Spevnik.init()

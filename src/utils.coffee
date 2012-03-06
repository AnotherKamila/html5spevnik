# This file contains various utilities used across all other files.

# I don't like window
top = exports ? this
top.top = top

# I do like logging
top.log = (args...) -> console.log.apply console, args
top.err = (args...) -> args.unshift 'ERR:'; console.warn.apply console, args

# ### browser stuff ###
top.indexedDB or= webkitIndexedDB or mozIndexedDB or moz_indexedDB

# alias addEvents
Element.alias 'on', 'addEvents'; Elements.alias 'on', 'addEvents'; window.on = window.addEvents; document.on = document.addEvents # TODO find a way to alias it just once

# make sure console exists
top.console or= { log: (->), warn: (->) }

# This file contains various utilities used across all other files.

# I don't like window
top = exports ? this
top.top = top

# I do like logging
top.log = (args...) -> console.log.apply console, args
top.err = (args...) -> args.unshift 'ERR:'; console.warn.apply console, args

# ### browser stuff ###
window.indexedDB or= webkitIndexedDB or mozIndexedDB or moz_indexedDB

# make sure console exists
window.console or= { log: (->), warn: (->) }

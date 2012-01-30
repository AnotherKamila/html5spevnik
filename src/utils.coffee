# This file contains various utilities used across all other files.

# I don't like window
top = exports ? window
top.top = top

# ### Other small things ###
window.document.head or= document.getElementsByTagName('head')[0]

# make sure that console exists
window.console = { log: (->), warn: (->) } unless console?

# This file contains various utilities used across all other files.

# ### module (function) ###
#
# a helper function for convenient creation of namespaced modules
#
# Pass it a name (can be in the form of `Foo.Bar.Baz`) and a function that
# accepts a single argument and attaches public properties and methods to it.
#
# For examples look at existing modules.
#
# Basically stolen from
# <http://github.com/jashkenas/coffee-script/wiki/FAQ> (look for namespace)
module = (name, module_fn) ->
    top = (exports if exports?) or window
    # create the namespace
    ns = top; ns = ns[item] or= {} for item in name.split '.'
    # execute the module function with the appropriate namespace that exports
    # can be attached to
    module_fn ns

window.module = module

# ### Other small things ###
#
# HTML5 brings a neat `document.head` thing, but not all browsers have it
window.document.head or= document.getElementsByTagName('head')[0]

# make sure that console exists
window.console = { log: (->), warn: (->) } unless console?

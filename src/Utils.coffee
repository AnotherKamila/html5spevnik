# This file contains various utilities used across all other files.
#
# For the bright future with auto dependencies: push me to the beginning  
# Depends: nothing

# Reference to the top-level object (for people like me who don't like `window`)
top = (exports if exports?) or window
top.top = top

# A helper function for convenient creation of namespaced modules
#
# Pass it a name (can be in the form of `Foo.Bar.Baz`) and a function that
# accepts a single argument and attaches public properties and methods to it.
#
# For examples look at existing modules.
#
# Basically stolen from
# <http://github.com/jashkenas/coffee-script/wiki/FAQ> (look for namespace)
module = (name, module_fn) ->
    # create the namespace
    ns = top; ns = ns[item] or= {} for item in name.split '.'
    # execute it with the appropriate namespace that exports can be attached to
    module_fn ns

top.module = module

# HTML5 has a neat `document.head` thing, but we may need to emulate it in some
# browsers
top.document.head or= document.getElementsByTagName('head')[0]

# make sure that console exists
top.console = { log: (->), warn: (->) } unless console?

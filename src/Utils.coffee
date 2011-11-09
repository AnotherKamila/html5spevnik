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
# Private properties can be defined inside the module as `@foo`, they are only
# accessible to functions inside the module.
#
# Note: Methods should of course use `=>` if they want to keep the context.
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

# make sure that console exists
console = { log: (->), warn: (->) } unless console?

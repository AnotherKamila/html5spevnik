# This file only serves as a sentinel for the modules loading stage.
#
# It is the last script in `<head>`, and since head scripts are executed
# synchronously in order, it will always be the last thing loaded (and
# executed).
#
# It fires an `allModulesLoaded` event, which then signals ''backend'' modules
# like `DB` that all ''client'' modules that were supposed to tell it something
# have by now done so, and its `init` method can now be called.
#
# For the automated dependency management that I am going to get at some point:
# Depends: all

S.fireEvent 'allModulesLoaded'

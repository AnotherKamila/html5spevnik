# This file only serves as a sentinel for the modules loading stage.
#
# It is the last script in `<head>`, and since head scripts are executed
# synchronously in order, it will always be the last thing loaded (and
# executed).
#
# It fires an `allModulesLoaded` event, which signals modules that from now on
# they can assume that an external world exists (therefore they can start
# producing events etc).

S.fireEvent 'allModulesLoaded'

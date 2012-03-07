# This file only serves as a sentinel for the modules loading stage, causing
# initialization when everything has finished loading.
#
# It is the last script in `<head>`, and since head scripts are executed
# synchronously in order, it will always be the last thing loaded (and
# executed).
log '=== Component initialization started ==='
S.say 'allModulesLoaded'

S.hookto 'allModulesLoaded:done', -> log '=== Initialization finished ==='

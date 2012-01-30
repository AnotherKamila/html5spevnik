# This file only serves as a sentinel for the modules loading stage, causing
# initialization when everything has finished loading.
#
# It is the last script in `<head>`, and since head scripts are executed
# synchronously in order, it will always be the last thing loaded (and
# executed).
S.run 'init'

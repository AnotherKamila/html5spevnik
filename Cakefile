fs     = require 'fs'
{exec} = require 'child_process'

log = console.log

srcDir   = 'src'
buildDir = 'build'

# -----------------------------------------------

ensureDir = (dir, callback) ->
    exec "mkdir -p #{dir}", callback

# -----------------------------------------------

task 'html', 'Create HTML files from Jade templates', ->
    ensureDir buildDir
    exec "jade --out #{buildDir} #{srcDir}/*.jade", (err, stdout, stderr) ->
        throw err if err
        log stderr if stderr

task 'js', 'Compile CoffeeScript files', ->
    ensureDir buildDir
    exec "coffee --compile --output #{buildDir} #{srcDir}/*.coffee", (err, stdout, stderr) ->
        throw err if err
        log stdout + stderr if stdout or stderr

task 'all', 'Do all the stuff necessary to get a ready build', ->
    invoke 'html'
    invoke 'js'

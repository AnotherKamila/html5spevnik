fs     = require 'fs'
{exec} = require 'child_process'

log = console.log

srcDir   = 'src'
buildDir = 'build'

# -----------------------------------------------

ensureDir = (dir, callback) ->
    exec "mkdir -p #{dir}", callback

execCallback = (err, stdout, stderr) ->
    throw err if err
    log stderr if stderr

# -----------------------------------------------

task 'html', 'Create HTML files from Jade templates', ->
    ensureDir buildDir, ->
        exec "jade --out #{buildDir} #{srcDir}/*.jade", execCallback

task 'js', 'Compile CoffeeScript files', ->
    ensureDir buildDir, ->
        exec "coffee --compile --output #{buildDir} #{srcDir}/*.coffee", execCallback
        exec "cp -r #{srcDir}/libs #{buildDir}", execCallback

task 'docs', 'Generate documentation/annotated source code with Docco', ->
    ensureDir 'docs/', ->
        exec "docco #{srcDir}/*.coffee", execCallback

task 'all', 'Do all the stuff necessary to get a ready build', ->
    invoke 'html'
    invoke 'js'
    invoke 'docs'

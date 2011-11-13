fs     = require 'fs'
{exec} = require 'child_process'

log = console.log

srcDir   = 'src'
buildDir = 'docs/build'

# -----------------------------------------------

ensureDir = (dir, callback) ->
    exec "mkdir -p #{dir}", callback

execCallback = (err, stdout, stderr) ->
    throw err if err
    log stderr if stderr

# -----------------------------------------------

task 'mkscripts', 'Generates a list of all libs and scripts to include in HTML', ->
    exec "ls -1 libs/*.js", (err, stdout, stderr) ->
        throw err if err
        libs = stdout.split('\n').filter (line) -> !!line
        res = ( "script(src='#{f}')" for f in libs ).join '\n'
        fs.writeFile "#{buildDir}/libs.jade", res, 'utf-8'

    # The ordering is OK in the following, since the only requirement is that
    # submodules come after their module, which is always the case if their
    # file names are `Module.Submodule.coffee` (note the capital S!!!) and we
    # sort alphabetically in reverse order
    invoke 'js'
    # about LC_COLLATE see
    # http://stackoverflow.com/questions/4834353/what-is-up-with-a-z-meaning-a-za-z
    exec "export LC_COLLATE=POSIX && ls -1 --reverse #{buildDir}/[A-Z]*.js", (err, stdout, stderr) ->
        throw err if err
        sources = stdout.split('\n').filter (line) -> !!line
        res = ( "script(src='#{ f.replace buildDir + '/', '' }')" for f in sources ).join '\n'
        fs.writeFile "#{buildDir}/sources.jade", res, 'utf-8'

task 'html', 'Create HTML from the Jade template', ->
    invoke 'mkscripts'
    ensureDir buildDir, ->
        exec "cp #{srcDir}/spevnik.jade #{buildDir}/", execCallback
        exec "jade --out #{buildDir} #{buildDir}/spevnik.jade", execCallback

task 'js', 'Compile CoffeeScript files', ->
    ensureDir buildDir, ->
        exec "coffee --compile --output #{buildDir} #{srcDir}/*.coffee", execCallback
        exec "cp -r libs/ #{buildDir}/", execCallback

task 'docs', 'Generate documentation/annotated source code with Docco', ->
    ensureDir 'docs/', ->
        exec "docco #{srcDir}/*.coffee", execCallback

task 'all', 'Do all the stuff necessary to get a ready build', ->
    invoke 'js'
    invoke 'html'
    invoke 'docs'

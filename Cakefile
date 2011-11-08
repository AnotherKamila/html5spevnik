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

task 'deps', 'Reads src/deps.txt and includes it in generated HTML', ->
    deps = fs.readFileSync "#{srcDir}/deps.txt", 'utf-8'
    deps = deps.split('\n').filter (line) -> line and not line.match '^\s*#'
    scripttags = ( "script(src='#{d}.js')" for d in deps ).join '\n'
    fs.writeFile "#{srcDir}/deps.jade", scripttags, 'utf-8'

task 'srclist', 'Reads src/deps.txt and makes html list items out of it', ->
    deps = fs.readFileSync "#{srcDir}/deps.txt", 'utf-8'
    deps = deps.split('\n').filter (line) -> line and not ((line.match /^\s*#/) or (line.match /^libs\//))
    list = ( "<li><a href='#{d}.html'>#{d}</a></li>" for d in deps ).join ''
    fs.writeFile "docs/_includes/srclist.html", list, 'utf-8'

task 'html', 'Create HTML from the Jade template', ->
    invoke 'deps'
    ensureDir buildDir, ->
        exec "jade --out #{buildDir} #{srcDir}/spevnik.jade", execCallback

task 'js', 'Compile CoffeeScript files', ->
    ensureDir buildDir, ->
        exec "coffee --compile --output #{buildDir} #{srcDir}/*.coffee", execCallback
        exec "cp -r #{srcDir}/libs #{buildDir}/", execCallback

task 'docs', 'Generate documentation/annotated source code with Docco', ->
    invoke 'srclist'
    ensureDir 'docs/', ->
        exec "docco #{srcDir}/*.coffee", execCallback

task 'all', 'Do all the stuff necessary to get a ready build', ->
    invoke 'html'
    invoke 'js'
    invoke 'docs'

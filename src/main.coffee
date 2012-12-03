argv = require('optimist').default({C: '.'}).argv
index = require './index'
get_articles = require './articles'
serve = require './serve'

main = ->
    callback = (articles) ->
        serve(index(articles))
    
    workingpath = argv.C
    get_articles(workingpath, callback)

    if argv._[0]?
        try
            cmd = require "./#{ argv._[0] }"
        catch error
            console.log "'#{ argv._[0] }' - no such command"
        
    if cmd
        cmd()
        
module.exports.main = main

http = require('http')
httpProxy = require('http-proxy')

wintersearch_port = '3000'
wintersmith_port = '8080'
preview_port = '8000'

preview = ->
    #
    # start proxy server
    #
    options = {
        router: {
        'localhost/search/': '127.0.0.1:' + wintersearch_port + '/search/',
        'localhost/': '127.0.0.1:' + wintersmith_port
        }
    }

    proxyServer = httpProxy.createServer(options)
    proxyServer.listen(preview_port)
    
    #
    # start wintersmith preview
    #
    util = require("util")
    spawn = require("child_process").spawn

    # http://stackoverflow.com/questions/7464036/node-js-shell-script-and-arguments
    console.log wintersmith_port
    ls = spawn("wintersmith", [ "preview", "-p", wintersmith_port ])
    ls.stdout.on "data", (data) ->
        process.stdout.write data.toString()

    ls.stderr.on "data", (data) ->
        process.stdout.write data.toString()

    ls.on "exit", (code) ->
        console.log "wintersmith exited with code " + code

module.exports = preview
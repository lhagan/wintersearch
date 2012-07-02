express = require 'express'
natural = require 'natural'

serve = (projectSearchCollection) ->
  search = (terms, callback) ->
    natural.PorterStemmer.attach()
    terms = terms.tokenizeAndStem().join(" ")
    # TODO: don't return the description, just the title and url are needed
    results = projectSearchCollection.setSearchString(terms).query().toJSON()
    callback results
  
  app = express.createServer()
  app.get '/', (request, response) ->
    if request.query.hasOwnProperty 'q'
      terms = request.query.q
      callback = (output) ->
        response.send output
      search(terms, callback)
    else
      response.send "Invalid request\n", 404

  app.configure ->
    app.use express.methodOverride()
    app.use express.bodyParser()
    app.use express.static(__dirname + "/static")
    app.use express.errorHandler(
      dumpExceptions: true
      showStack: true
    )
    app.use app.router

  app.listen 3000

module.exports = serve
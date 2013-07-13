wintersmith = require 'wintersmith'
_ = require('underscore')._
natural = require 'natural'
path = require 'path'

get_articles = (workingpath, callback) ->
    config = path.join workingpath, "config.json"
    env = wintersmith config
    env.load (error, contents) ->
        natural.PorterStemmer.attach()
        articles = []
        scan = (item) ->
            _.chain(item).each (subitem) ->
                if subitem
                    node = subitem["index.md"]
                    if node
                      if node.title
                          console.log node.url
                          articles.push
                              title: node.title
                              title_token: node.title.tokenizeAndStem().join(" ")
                              url: node.url
                              body: node.markdown.tokenizeAndStem().join(" ")
                      if typeof(node) is "object"
                          if Object.keys(node) > 1
                              scan subitem if item
        
        directories = _.chain(contents.contents)
        pages = directories.each((item) ->
            scan item
        )
        
        callback(articles)

module.exports = get_articles

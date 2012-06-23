queryEngine = require 'query-engine'

index = (articles) ->
    projectCollection = queryEngine.createLiveCollection(articles)
    
    projectSearchCollection = projectCollection.createLiveChildCollection()
        .setPill('id', {
            prefixes: ['id:']
            callback: (model,value) ->
                pass = model.get('id') is parseInt(value,10)
                return pass
        })
        .setPill('tag', {
            logicalOperator: 'AND'
            prefixes: ['tag:']
            callback: (model,value) ->
                for tag in model.get('tags')
                    searchRegex = queryEngine.createSafeRegex(value)
                    pass = searchRegex.test(tag)
                    break  if pass
                return pass
        })
        .setPill('title', {
            prefixes: ['title:']
            callback: (model,value) ->
                valueRegex = queryEngine.createSafeRegex(value)
                pass = valueRegex.test(model.get('title'))
                return pass
        })
        .setFilter('search', (model,searchString) ->
            return true  unless searchString?
            searchRegex = queryEngine.createSafeRegex(searchString)
            pass = searchRegex.test(model.get('body'))
            return pass
        )
        .query()
        
    return projectSearchCollection

module.exports = index
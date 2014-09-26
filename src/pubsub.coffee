# code lifted from
# [https://github.com/jackfranklin/CoffeePubSub]
# and adapted to become a singleton powered 'Channel'.

module.exports = class Channel
  instance = null
  class PubSub
    constructor: ->
      @subs = {}
    
    subscribe: (evt, cb, id='default') ->
      if @_isSubscribed evt
        sub = @subs[evt]
        sub.push {id: id, callback: cb}
      else
        @subs[evt] = [{id: id, callback: cb}]

    _isSubscribed: (evt) ->
      @subs[evt]?

    unSubscribe: (id, evt) ->
      return false if not @_isSubscribed evt
      newSubs = []
      for sub in @subs[evt]
        newSubs.push sub if sub.id isnt id
      if newSubs.length is 0
        delete @subs[evt]
      else
        @subs[evt] = newSubs

    publish: (evt, info) ->
      for key, val of @subs
        return false if not val?
        if key is evt
          for data in val
            data.callback(info)
  @get = ->
    instance ?= new PubSub()

Channel = require './pubsub'


module.exports.wallListener = (node) ->
    node.mousedown = node.touchstart = (event) ->
        event.originalEvent.preventDefault()
        @data = event
        @dragging = true
        local = @data.getLocalPosition(@parent)
        @dx = @position.x - local.x
        @dy = @position.y - local.y
        Channel.get().publish 'start move wall', {node:@}
        
    node.mouseup = node.mouseupoutside = node.touchend = node.touchendoutside = ->
        @dragging = false
        @data = null

    node.mousemove = node.touchmove = (event) ->
        if @dragging
            local = @data.getLocalPosition(@parent)
            deltaX = @position.x - (local.x + @dx)
            deltaY = @position.y - (local.y + @dy)
            Channel.get().publish 'move wall', {node:@, deltaX:deltaX,deltaY:deltaY,scale:@parent.scale}
                

module.exports.stageListener = (node, container) ->
    node.mousedown = node.touchstart = (event) ->
        event.originalEvent.preventDefault()
        @data = event
        @dragging = true
        @dx = container.position.x - event.global.x
        @dy = container.position.y - event.global.y 

    node.mouseup = node.mouseupoutside = node.touchend = node.touchendoutside = ->
        @dragging = false
        @data = null

    node.mousemove = node.touchmove = (event) ->
        if @dragging
            newpos = @data.getLocalPosition(node.parent)
            container.position.x = newpos.x + @dx
            container.position.y = newpos.y + @dy
            Channel.get().publish 'render'

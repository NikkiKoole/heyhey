{wallListener, stageListener, itemListener} = require './listeners'
eventBus = require './bus'


pixiCanvas = document.getElementById('canvas')
pixiCanvas.ondrop = (event) ->
    event.preventDefault()
    data = event.dataTransfer.getData("text/plain")
    if data.indexOf('Room') is 0
        eventBus.emit 'change room', {ev:event, button:data}
    else if data.indexOf('Furniture') is 0
        eventBus.emit 'add item', {ev:event, button:data}
        
    else if data.indexOf('Opening') is 0
        console.log 'add Opening'

pixiCanvas.ondragover = (event) ->
    event.preventDefault()




renderer = new PIXI.autoDetectRenderer(window.innerWidth, window.innerHeight, pixiCanvas)

# shoud be in a line utils file
getAngleBetweenTwoPoints = (start, end) ->
    xdiff = end[0] - start[0]
    ydiff = end[1] - start[1]
    Math.atan2(ydiff, xdiff)# * (180 / Math.PI)

getMiddlePoint = (start, end) ->
    x: start[0] + (end[0] - start[0])/2
    y: start[1] + (end[1] - start[1])/2

getDistance = (start, end) ->
    xdiff = end[0] - start[0]
    ydiff = end[1] - start[1]
    Math.sqrt((xdiff * xdiff) + (ydiff * ydiff))

module.exports = class Canvas extends PIXI.Stage
    constructor: ->
        super(0xff0000)
        @drawnWalls = []
        @drawnFurnitures = []
        @container = new PIXI.DisplayObjectContainer()
        @overlay = new PIXI.DisplayObjectContainer()
        @overlay.interactive = true
        @overlay.hitArea = new PIXI.Rectangle(0,0,window.innerWidth, window.innerHeight)
        @addChild @overlay
        @addChild @container
        stageListener @overlay, @container
        @render()
        
    render:->
        @updateWalls()
        renderer.render @

    addItem: (data)->
        itemContainer = new PIXI.DisplayObjectContainer()
        graphics = new PIXI.Graphics()
        graphics.beginFill 0xfffff * Math.random()
        graphics.drawRect 0,0,400,400
        itemContainer.addChild graphics
        @drawnFurnitures.push itemContainer
        itemContainer.pivot = new PIXI.Point(0.5, 0,5)
        itemContainer.rotation = (360) * Math.random()
        itemContainer.position.x = (data.ev.pageX - @container.position.x) / @scale
        itemContainer.position.y = (data.ev.pageY - @container.position.y) / @scale
        @container.addChild itemContainer
        itemContainer.hitArea = new PIXI.Rectangle(0,0,400,400)
        itemContainer.interactive = true
        itemListener itemContainer
        
        renderer.render @
        
    
    centreAndScalePlan: (bbox) ->
        scaleX = window.innerWidth / @getBBoxSize(bbox).width
        scaleY = window.innerHeight / @getBBoxSize(bbox).height
        @scale = Math.min(scaleX, scaleY) * 0.9
        xOff = ( window.innerWidth / @scale - @getBBoxSize(bbox).width ) / 2
        yOff = ( window.innerHeight / @scale - @getBBoxSize(bbox).height ) / 2
        @container.scale.x = @container.scale.y = @scale
        @container.position.x = (-bbox.min.x + xOff) * @scale
        @container.position.y = (-bbox.min.y + yOff) * @scale

    updateWalls: ->
        for drawn in @drawnWalls
            wall = drawn.represents
            drawn.removeChildAt(0)
            wallGraphics = new PIXI.Graphics()
            wallGraphics.beginFill 0xffff00
            wallGraphics.drawRect(0,0,getDistance(wall.a, wall.b), 50)
            drawn.addChild wallGraphics
            drawn.hitArea = new PIXI.Rectangle(0,0,getDistance(wall.a, wall.b), 50)
            drawn.position.x = wall.a[0]
            drawn.position.y = wall.a[1]
            drawn.rotation = getAngleBetweenTwoPoints(wall.a, wall.b)
            #@container.addChild wallContainer
            

    
    buildPlan: (floorplan, bbox) ->
        for wall in floorplan.walls
            wallContainer = new PIXI.DisplayObjectContainer()
            wallGraphics = new PIXI.Graphics()
            wallGraphics.beginFill 0xffff00
            wallGraphics.drawRect(0,0,getDistance(wall.a, wall.b), 50)
            wallContainer.addChild wallGraphics
            wallContainer.hitArea = new PIXI.Rectangle(0,0,getDistance(wall.a, wall.b), 50)
            wallContainer.position.x = wall.a[0]
            wallContainer.position.y = wall.a[1]
            wallContainer.rotation = getAngleBetweenTwoPoints(wall.a, wall.b)
            @container.addChild wallContainer
            wallContainer.interactive = true
            wallContainer.represents = wall
            @drawnWalls.push wallContainer
            wallListener wallContainer
        @centreAndScalePlan(bbox)
        @render()

    getBBoxSize: (bbox) ->
        width: (bbox.max.x - bbox.min.x)
        height:(bbox.max.y - bbox.min.y)



                

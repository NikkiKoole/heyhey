Channel = require './pubsub'
{wallListener, stageListener} = require './listeners'

renderer = new PIXI.autoDetectRenderer(window.innerWidth, window.innerHeight)
document.body.appendChild renderer.view

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
        @container = new PIXI.DisplayObjectContainer()
        @overlay = new PIXI.DisplayObjectContainer()
        @overlay.interactive = true
        @overlay.hitArea = new PIXI.Rectangle(0,0,window.innerWidth, window.innerHeight)
        @addChild @overlay
        @addChild @container
        stageListener @overlay, @container
        @render()
        
    render:->
        renderer.render @

    centreAndScalePlan: (bbox) ->
        scaleX = window.innerWidth / @getBBoxSize(bbox).width
        scaleY = window.innerHeight / @getBBoxSize(bbox).height
        scale = Math.min(scaleX, scaleY) * 0.9
        xOff = ( window.innerWidth / scale - @getBBoxSize(bbox).width ) / 2
        yOff = ( window.innerHeight / scale - @getBBoxSize(bbox).height ) / 2
        @container.scale.x = @container.scale.y = scale
        @container.position.x = (-bbox.min.x + xOff) *scale
        @container.position.y = (-bbox.min.y + yOff) *scale
            
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
            wallListener wallContainer
        @centreAndScalePlan(bbox)
        @render()

    getBBoxSize: (bbox) ->
        width: (bbox.max.x - bbox.min.x)
        height:(bbox.max.y - bbox.min.y)



                

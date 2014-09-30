#Floorplan = require '../../fp.engine2/src/floorplan/floorplan'
#bbox = require '../../fp.engine2/src/util/bbox'
{Floorplan, bbox} = require 'fp.engine2'
eventBus = require './bus'

Canvas = require './canvas'
SideBar = require './sidebar'
{example} = require '../resources/example_plan'

canvas =  null
sidebar = null

floorplan = new Floorplan()
example(floorplan) # a predefined room for Razorfish demo

window.onload = ->
    canvas = new Canvas() # a pixi powered canvas that draws the plan and receives user input (touch/mouse)
    sidebar = new SideBar() # a html based UI that dispatches events over the Channel
    canvas.buildPlan(floorplan, bbox(floorplan))

    # render
    eventBus.on 'render', ->
        canvas.render()
    # drawmode
    eventBus.on 'change drawmode', (data) ->
        0
    # rooms
    eventBus.on 'change room', (data) ->
        0
    #openings
    eventBus.on 'add opening', (data) ->
        0
    # items
    eventBus.on 'add item', (data) ->
        console.log 'receiving add item', data
        canvas.addItem(data)
    eventBus.on 'transform item', (data) ->
        0
    eventBus.on 'delete item', (data) ->
        0
    eventBus.on 'color item', (data) ->
        0
    # walls
    eventBus.on 'add wall', (data) ->
        0
    eventBus.on 'start move wall', (data) ->
        floorplan._beforeMoveWall(data.node.represents)
    
    eventBus.on 'move wall', (data) ->
        info = floorplan.moveWall(data.node.represents, data.deltaX, data.deltaY)
        # if info would contain extra walls here I can update the sysytem  about that.
        eventBus.emit 'render'







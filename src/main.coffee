#Floorplan = require '../../fp.engine2/src/floorplan/floorplan'
#BBox = require '../../fp.engine2/src/util/bbox'
{Floorplan, bbox} = require 'fp.engine2'

Channel = require './pubsub'
Canvas = require './canvas'
SideBar = require './sidebar'

{example} = require '../resources/example_plan'

canvas =  null
sidebar = null
channel = null

floorplan = new Floorplan()
example(floorplan) # a predefined room for Razorfish demo

window.onload = ->

    canvas = new Canvas() # a pixi powered canvas that draws the plan and receives user input (touch/mouse)
    sidebar = new SideBar() # a html based UI that dispatches events over the Channel
    channel = Channel.get()  # a Singleton channel over which all communication goes.
    canvas.buildPlan(floorplan, bbox(floorplan))

    # render
    channel.subscribe 'render', ->
        canvas.render()
    
    # drawmode
    channel.subscribe 'change drawmode', (data) ->
        0
    # rooms
    channel.subscribe 'change room', (data) ->
        0
    # items
    channel.subscribe 'add item', (data) ->
        0
    channel.subscribe 'transform item', (data) ->
        0
    channel.subscribe 'delete item', (data) ->
        0
    channel.subscribe 'color item', (data) ->
        0

    # walls
    channel.subscribe 'add wall', (data) ->
        0
    channel.subscribe 'start move wall', (data) ->
        floorplan._beforeMoveWall(data.node.represents)
    
    channel.subscribe 'move wall', (data) ->
        data.node.position.x -= data.deltaX
        data.node.position.y -= data.deltaY
        dx = -data.deltaX/data.scale.x
        dy = -data.deltaX/data.scale.y
        newWalls = floorplan.moveWall(data.node.represents, dx, dy)
        console.log dx, dy, newWalls
        channel.publish 'render'

    Channel.get().publish('change room', {})






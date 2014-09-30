# thisd sidebar will lay on top of the pixi canvas
content = require '../resources/sidebar_data'

openState = (node, value) ->
    node.isOpen = value

cssTransitionsNoThanks = (node) ->
    node.onclick = ->
        parent = node.parentNode
        duration = parseInt(parent.fullHeight)/1000
        if parent.isOpen
           TweenLite.to(parent, duration, {height:60,  onComplete:openState, onCompleteParams:[parent, false]})
        else
           TweenLite.to(parent, duration, {height:parent.fullHeight,  onComplete:openState, onCompleteParams:[parent, true]})

module.exports = class SideBar

    constructor: ->
        @side = document.body.appendChild(document.createElement('div'))
        @side.className = 'sidebar'
        #@side.draggable = true
        for section in content.sections
            #(@buildButton section.buttonImages[key], @side, key) for own key of section.buttonImages
            sec = document.createElement('section')
            sec.id = section.title
            #titleContainer = document.createElement('div')
            title = document.createElement('h4')
            cssTransitionsNoThanks title
            title.innerHTML = section.title
            sec.appendChild title#Container
            p = document.createElement('p')
            sec.appendChild p
            
            (@buildButton section.buttonImages[key], p, key) for own key of section.buttonImages
            @side.appendChild sec
            console.log sec.style
            sec.fullHeight = window.getComputedStyle(sec,null).getPropertyValue("height")
        colorpicker = document.createElement('div')
         
    buildButton: (data, container, key)->
        #console.log data, container
        button = document.createElement('div')
        button.className = 'imageButton'
        button.draggable = true
        button.ondragstart = (event) ->
            event.dataTransfer.setData("text/plain", event.target.id)
        button.onmousedown = ->
            console.log 'mousedown'
            
        button.id = key
        button.style.width = '46px'
        button.style.height = '46px'
        button.style.src = '../resources/spacer.png'
        button.style.background = "url('../resources/spritesheet.png') -#{data.x}px -#{data.y}px no-repeat"
        container.appendChild button
        

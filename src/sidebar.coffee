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
           TweenLite.to(parent.arrow, duration, {rotation:90})
        else
           TweenLite.to(parent, duration, {height:parent.fullHeight,  onComplete:openState, onCompleteParams:[parent, true]})
           TweenLite.to(parent.arrow, duration, {rotation:270})

setSectionState = (section, open) ->
    0


module.exports = class SideBar
    constructor: ->
        @side = document.body.appendChild(document.createElement('div'))
        @side.className = 'sidebar'

        for section in content.sections
            sec = document.createElement('section')
            sec.id = section.title
            titleContainer = document.createElement('div')
            titleContainer.id = 'titleContainer'
            title = document.createElement('h5')
            cssTransitionsNoThanks titleContainer
            title.innerHTML = section.title
            title.id = 'titleText'
            titleContainer.appendChild title
            arrow = document.createElement('h5')
            arrow.innerHTML = '>'
            sec.arrow = arrow
            TweenLite.to(arrow, 0.0001, {rotation:270})
            arrow.id = 'titleArrow'
            titleContainer.appendChild arrow
            sec.appendChild titleContainer
            p = document.createElement('p')
            p.id = 'imagebuttonContainer'
            sec.appendChild p
            (@buildButton section.buttonImages[key], p, key) for own key of section.buttonImages
            @side.appendChild sec
            console.log sec.style
            sec.isOpen  = true
            sec.fullHeight = window.getComputedStyle(sec,null).getPropertyValue("height")
        colorpicker = document.createElement('div')
         
    buildButton: (data, container, key) ->
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
        

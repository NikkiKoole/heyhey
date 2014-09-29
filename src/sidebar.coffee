# thisd sidebar will lay on top of the pixi canvas
content = require '../resources/sidebar_data'

module.exports = class SideBar
    constructor: ->
        @side = document.body.appendChild(document.createElement('div'))
        @side.className = 'sidebar'
        #@side.draggable = true
        for section in content.sections
            #(@buildButton section.buttonImages[key], @side, key) for own key of section.buttonImages
            
            sec = document.createElement('section')
            sec.id = section.title
            title = document.createElement('h4')
            link = document.createElement('a')
            link.href = '#'+section.title
            link.innerHTML = section.title
            title.appendChild link
            #title.innerHTML = section.title
            sec.appendChild title
            p = document.createElement('p')
            sec.appendChild p
            (@buildButton section.buttonImages[key], p, key) for own key of section.buttonImages
            @side.appendChild sec
         
    buildButton: (data, container, key)->
        #console.log data, container
        button = document.createElement('div')
        button.className = 'imageButton'
        button.draggable = true
        button.ondragstart = (event) ->
            event.dataTransfer.setData("text/html", event.target.id)
        button.onmousedown = ->
            console.log 'mousedown'
            
        button.id = key
        button.style.width = '46px'
        button.style.height = '46px'
        button.style.src = '../resources/spacer.png'
        button.style.background = "url('../resources/spritesheet.png') -#{data.x}px -#{data.y}px no-repeat"
        container.appendChild button
        

module.exports.example = (floorplan) ->
    floorplan.addWall({a:{x:1000, y:1000}, b:{x:5500, y:1000}, thickness:200})
    floorplan.addWall({a:{x:5500, y:1000}, b:{x:5500, y:3500}, thickness:200})
    floorplan.addWall({a:{x:5500, y:3500}, b:{x:3500, y:3500}, thickness:200})
    floorplan.addWall({a:{x:3500, y:3500}, b:{x:3500, y:5500}, thickness:200})
    floorplan.addWall({a:{x:3500, y:5500}, b:{x:1000, y:5500}, thickness:200})
    floorplan.addWall({a:{x:1000, y:5500}, b:{x:1000, y:1000}, thickness:200})

    floorplan.addAsset({id:'square78', url2d:'none', layer:2})
    floorplan.addItem({refid:'square78', type:'furniture', position:{x:1600, y:1600}, size:{width:200, height:200}})
    floorplan.addItem({refid:'square78', type:'furniture', position:{x:1600, y:2800}, size:{width:200, height:200}})
    floorplan.addItem({refid:'square78', type:'furniture', position:{x:2800, y:4800}, size:{width:200, height:200}})
    floorplan.addItem({refid:'square78', type:'furniture', position:{x:4900, y:1600}, size:{width:200, height:200}})

{Floorplan} = require '../src/floorplan/floorplan'

describe 'the floorplan', ->
    it 'constructs', ->
        expect(new Floorplan).toBeTruthy()

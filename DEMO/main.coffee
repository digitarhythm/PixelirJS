id = undefined
onload =->
    width = 480
    height = 320
    app = new pixelir_core
        screen_width: width
        screen_height: height
        canvas_color: 'black'
        bg_color: 'gray'
        #canvas_2d: 'pixijs'
        #canvas_3d: 'threejs'
        #dot_by_dot: true
    app.createLayer()
    app.createLayer()

    resource = [
        'image/chara1.png'
    ]

    app.preload resource
    , (assets)->
        keys = Object.keys(assets)
        img = assets[keys[0]]
        sprite1 = app.newSprite
            x: 16
            y: height / 2
            image: img
            frameeIndex: 0
            wscale: 2.0
            hscale: 2.0
        sprite2 = app.newSprite
            x: 180
            y: height / 2
            width: 160
            height: 96
            image: img
            wscale: 1.5
            hscale: 1.5
        sprite3 = app.newSprite
            x: width - 140
            y: height / 2
            width: 160
            height: 96
            image: img

        app.addSprite(sprite1, 1)
        app.addSprite(sprite2, 2)
        app.addSprite(sprite3, 0)

        date = new Date()
        epoc = date.getTime()
        app.enterframe ->
            date = new Date()
            now = date.getTime()
            #JSLog("now=%@, epoc=%@", now, epoc)
            if (now > epoc + 100.0)
                date = new Date()
                epoc = date.getTime()
                sprite1.x += 8
                if (sprite1.x > app.SCREEN_WIDTH)
                    sprite1.x = 0
                sprite1.rotate += 36.0
                if (sprite1.rotate > 360.0)
                    sprite1.rotate = 0.0
                sprite1.frameIndex += 1
                if (sprite1.frameIndex > 2)
                    sprite1.frameIndex = 0


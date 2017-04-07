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
        #DOT_BY_DOT: true
    app.createLayer()
    app.createLayer()

    resource = [
        'image/chara1.png'
    ]

    app.preload resource
    , (assets)->
        keys = Object.keys(assets)
        img = assets[keys[0]]
        sprite = app.newSprite
            x: 160
            y: height / 2
            width: 160
            height: 96
            image: img
        sprite2 = app.newSprite
            x: 16
            y: height / 2
            image: img
            frameeIndex: 0
            wscale: 2.0
            hscale: 2.0
        sprite3 = app.newSprite
            x: width - 160
            y: height / 2
            width: 160
            height: 96
            image: img

        date = new Date()
        epoc = date.getTime()
        app.enterframe ->
            app.drawSprite(sprite, 0)
            app.drawSprite(sprite2, 1)
            app.drawSprite(sprite3, 2)
            date = new Date()
            now = date.getTime()
            #JSLog("now=%@, epoc=%@", now, epoc)
            if (now > epoc + 100.0)
                date = new Date()
                epoc = date.getTime()
                sprite2.x += 8
                if (sprite2.x > app.SCREEN_WIDTH)
                    sprite2.x = 0
                sprite2.rotate += 36.0
                if (sprite2.rotate > 360.0)
                    sprite2.rotate = 0.0
                sprite2.frameIndex += 1
                if (sprite2.frameIndex > 2)
                    sprite2.frameIndex = 0


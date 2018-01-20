id = undefined
onload = ->
    console.clear()
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
    app.createLayer()

    resource = [
        'image/chara1.png'
    ]

    # リソースデータをプリロードする
    app.preload resource
    , (assets)->
        keys = Object.keys(assets)
        img = assets[keys[0]]

        sprite1 = app.newSprite
            x: 0
            y: height / 3
            xs: 4
            image: img
            frameeIndex: 0
            wscale: 3
            hscale: 3
            gravity: 1.0
            patternList: [
                [100, [0, 1, 0, 2]]
            ]

        sprite2 = app.newSprite
            x: 180
            y: height * 0.4
            width: 160
            height: 96
            image: img
            wscale: -1.5
            hscale: -1.5

        sprite3 = app.newSprite
            x: width - 140
            y: height * 0.6
            width: 160
            height: 96
            image: img

        app.addSprite(sprite1, 1)
        app.addSprite(sprite2, 2)
        app.addSprite(sprite3, 0)

        app.enterframe ->
            if (sprite1.x > app.SCREEN_WIDTH)
                sprite1.x = 0
            if (sprite1.y > height - sprite1.height * 2)
                sprite1.y = height - sprite1.height * 2
                sprite1.ys *= -1
            sprite1.rotate += 1.8
            if (sprite1.rotate > 360.0)
                sprite1.rotate = 0.0


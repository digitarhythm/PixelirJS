#****************************************************************************
#****************************************************************************
#****************************************************************************
#
# PixelirJS core library - pixelir_core.coffee
#
# 2016.11.17 Created by PROJECT PROMINENCE
#
#****************************************************************************
#****************************************************************************
#****************************************************************************

class pixelir_core
    # public variables
    @ASSETS = undefined
    @BROWSER_WIDTH = undefined
    @BROWSER_HEIGHT = undefined
    @SCREEN_WIDTH = undefined
    @SCREEN_HEIGHT = undefined
    @LAYERS = undefined
    @FPS = undefined

    # private variable
    _WEBCANVAS = undefined
    _WEBGL_LAYER = undefined
    _DISP_LAYER = undefined
    _CANVAS_2D = undefined
    _CANVAS_3D = undefined
    _SPRITE_LIST = {}

    _RAD = Math.PI / 180.0

    constructor:(arr)->
        if (!arr?)
            arr = []

        # get size
        @BROWSER_WIDTH = window.innerWidth
        @BROWSER_HEIGHT = window.innerHeight
        @SCREEN_WIDTH = if (arr['screen_width']?) then arr['screen_width'] else @BROWSER_WIDTH
        @SCREEN_HEIGHT = if (arr['screen_height']?) then arr['screen_height'] else @BROWSER_HEIGHT
        @FPS = if (arr['fps']?) then arr['fps'] else 60
        @LAYERS = []

        _CANVAS_2D = if (arr['canvas_2d']?) then arr['canvas_2d'] else 'pixelir'
        _CANVAS_3D = if (arr['canvas_3d']?) then arr['canvas_3d'] else 'pixelir'

        # set canvas parameter
        bg_color = if (arr['bg_color']?) then arr['bg_color'] else undefined
        canvas_color = if (arr['canvas_color']?) then arr['canvas_color'] else "black"
        dot_by_dot = if (arr['dot_by_dot']?) then arr['dot_by_dot'] else false
        posx = if (arr['posx']?) then arr['posx'] else undefined
        posy = if (arr['posy']?) then arr['posy'] else undefined

        requestAnimationFrame = window.requestAnimationFrame ||
                                window.mozRequestAnimationFrame ||
                                window.webkitRequestAnimationFrame ||
                                window.msRequestAnimationFrame
        window.requestAnimationFrame = requestAnimationFrame

        # create 2d canvas
        switch (_CANVAS_2D)
            when "pixelir"
                if (typeof(pixelir_canvas) != 'function' || typeof(pixelir_sprite) != 'function')
                    console.log("This library required 'pixelir_sprite'.")
                    _WEBCANVAS = undefined
                else
                    _WEBCANVAS = new pixelir_canvas
                        screen_width: @SCREEN_WIDTH
                        screen_height: @SCREEN_HEIGHT
                        canvas_color: canvas_color
                        bg_color: bg_color
                        dot_by_dot: dot_by_dot
                        canvas_2d: _CANVAS_2D
                        canvas_3d: _CANVAS_3D
                        posx: posx
                        posy: posy
                    _DISP_LAYER = (_WEBCANVAS.createCanvas {type:'2d', hidden:false}).getContext('2d')
                @createLayer()
            when "pixijs"
                nop()

        # create 3d canvas
        switch (_CANVAS_3D)
            when "pixelir"
                _WEBGL_LAYER = (_WEBCANVAS.createCanvas {type:'gl', hidden:true}).getContext('webgl')
            when "threejs"
                nop()

#****************************************************************************
#****************************************************************************
#****************************************************************************
#
# enterframe
#
#****************************************************************************
#****************************************************************************
#****************************************************************************
    enterframe:(func)->
        @__behavior(func)

    __behavior:(func)->
        if (_WEBCANVAS?)
            for context in @LAYERS
                @clearLayer(context)
            _WEBCANVAS.clearCanvas(_DISP_LAYER.canvas)
            func()
            for id, sprt of _SPRITE_LIST
                @__drawSprite(sprt)
            @__composeLayers()
            window.requestAnimationFrame =>
                @__behavior(func)


#****************************************************************************
#****************************************************************************
#****************************************************************************
#
# Sprite
#
#****************************************************************************
#****************************************************************************
#****************************************************************************

    #========================================================================
    # addSprite
    #========================================================================
    addSprite:(sprite, layer = 0)->
        sprite.layer = layer
        if (!_SPRITE_LIST[sprite.spriteID]?)
            _SPRITE_LIST[sprite.spriteID] = sprite

    #========================================================================
    # remove sprite
    #========================================================================
    removeSprite:(sprite)->
        if (_SPRITE_LIST[sprite.spriteID]?)
            delete _SPRITE_LIST[sprite.spriteID]

    #========================================================================
    # draw sprite
    #========================================================================
    __drawSprite:(sprite)->
        num = sprite.layer
        context = @LAYERS[num]
        if (context?)
            img = sprite.image
            width = sprite.image.width
            height = sprite.image.height
            spw = sprite.width
            sph = sprite.height
            x = sprite.x
            y = sprite.y
            frameIndex = sprite.frameIndex
            spwnum = Math.floor(width / spw)
            sphnum = Math.floor(height / sph)
            frame_x = (frameIndex % spwnum) * spw
            frame_y = (Math.floor(frameIndex / spwnum)) * sph

            context.save()
            context.translate(sprite.x, sprite.y)
            context.rotate(sprite.rotate * _RAD)
            context.translate(-(spw * sprite.wscale) / 2, -(sph * sprite.hscale) / 2)

            context.drawImage(img, frame_x, frame_y, spw, sph, 0, 0, spw * sprite.wscale, sph * sprite.hscale)

            context.restore()

    #========================================================================
    # image data preload
    #========================================================================
    __loadImages:(assets_list, func)->
        src = assets_list.shift(1)
        img = new Image()
        img.src = src
        img.onload = =>
            @ASSETS[src] = img
            if (assets_list.length > 0)
                @__loadImages(assets_list, func)
            else
                func(@ASSETS)

    #========================================================================
    # preload media file
    #========================================================================
    preload:(assets_list, func)->
        if (!assets_list?)
            return undefined

        @ASSETS = {}
        @__loadImages(assets_list, func)

    #========================================================================
    # create new sprite
    #========================================================================
    newSprite:(arr)->
        x = if (arr['x']?) then arr['x'] else 0
        y = if (arr['y']?) then arr['y'] else 0
        z = if (arr['z']?) then arr['z'] else 0
        frameIndex = if (arr['frameIndex']?) then arr['frameIndex'] else 0
        hidden = if (arr['hidden']?) then arr['hidden'] else false
        image = if (arr['image']?) then arr['image'] else undefined
        width = if (arr['width']?) then arr['width'] else 32
        height = if (arr['height']?) then arr['height'] else 32
        wscale = if (arr['wscale']?) then arr['wscale'] else 1.0
        hscale = if (arr['hscale']?) then arr['hscale'] else 1.0
        rotate = if (arr['rotate']?) then arr['rotate'] else 0.0
        if (typeof(pixelir_sprite) == 'function')
            sprite = new pixelir_sprite
                x: x
                y: y
                z: z
                frameIndex: frameIndex
                hidden: hidden
                image: image
                width: width
                height: height
                wscale: wscale
                hscale: hscale
                rotate: rotate
            return sprite
        else
            console.log("This method required pixelir_sprite.")


#****************************************************************************
#****************************************************************************
#****************************************************************************
#
# Layer
#
#****************************************************************************
#****************************************************************************
#****************************************************************************

    #****************************************************************************
    # create new layer
    #****************************************************************************
    createLayer:(arr = [])->
        hidden = if (arr['hidden']?) then arr['hidden'] else false

        context = _WEBCANVAS.createCanvas([hidden:hidden]).getContext('2d') if (_WEBCANVAS?)
        @LAYERS.push(context)
        return (@LAYERS.length) - 1

    #****************************************************************************
    # remove layer
    #****************************************************************************
    removeLayer:(num)->
        context = @LAYERS[num]
        _WEBCANVAS.removeCanvas(context.canvas) if (_WEBCANVAS?)

    #****************************************************************************
    # clear layer
    #****************************************************************************
    clearLayer:(context)->
        if (_WEBCANVAS?)
            if (!context?)
                for context in @LAYERS
                    _WEBCANVAS.clearCanvas(context.canvas)
            else
                _WEBCANVAS.clearCanvas(context.canvas)

    #****************************************************************************
    # compose all layer to disp layer
    #****************************************************************************
    __composeLayers:->
        if (_WEBGL_LAYER?)
            _DISP_LAYER.drawImage(_WEBGL_LAYER.canvas, 0, 0)
        if (_DISP_LAYER?)
            for context in @LAYERS
                canvas = context.canvas
                _DISP_LAYER.drawImage(canvas, 0, 0)


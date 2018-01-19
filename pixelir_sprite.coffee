#****************************************************************************
#****************************************************************************
#****************************************************************************
#
# PixelirJS Sprite Library - pixelir_sprite.coffee
#
# 2016.11.17 Created by PROJECT PROMINENCE
#
#****************************************************************************
#****************************************************************************
#****************************************************************************

class pixelir_sprite
    # public variables
    @x = undefined
    @y = undefined
    @z = undefined
    @frameIndex = undefined
    @hidden = undefined
    @image = undefined
    @width = undefined
    @height = undefined
    @scalew = undefined
    @scaleh = undefined
    @maxFrame = undefined
    @rotate = undefined
    @layer = undefined
    @spriteID = undefined
    @patternList = undefined
    @patternNum = undefined

    @_animetime = undefined

    # private variables

    constructor:(arr)->
        @x = if (arr['x']?) then arr['x'] else 0
        @y = if (arr['y']?) then arr['y'] else 0
        @z = if (arr['z']?) then arr['z'] else 0
        @xs = if (arr['xs']?) then arr['xs'] else 0
        @ys = if (arr['ys']?) then arr['ys'] else 0
        @zs = if (arr['zs']?) then arr['zs'] else 0
        @gravity = if (arr['gravity']?) then arr['gravity'] else 0
        @frameIndex = if (arr['frameIndex']?) then arr['frameIndex'] else 0
        @hidden = if (arr['hidden']?) then arr['hidden'] else false
        @image = if (arr['image']?) then arr['image'] else undefined
        @width = if (arr['width']?) then arr['width'] else 32
        @height = if (arr['height']?) then arr['height'] else 32
        @wscale = if (arr['wscale']?) then arr['wscale'] else 1.0
        @hscale = if (arr['hscale']?) then arr['hscale'] else 1.0
        @rotate = if (arr['rotate']?) then arr['rotate'] else 0.0
        @patternList = if (arr['patternList']?) then arr['patternList'] else [[100, [0]]]
        @patternNum = if (arr['patternNum']?) then arr['patternNum'] else 0
        @spriteID = if (arr['spriteID']?) then arr['spriteID'] else undefined

        @_animetime = new Date().getTime()
        img_width = @image.width
        img_height = @image.height
        spwnum = Math.floor(img_width / @width)
        sphnum = Math.floor(img_height / @height)
        @maxFrame = (spwnum * sphnum) - 1


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
  @object = undefined
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
  @animetime = undefined
  @mesh = undefined
  @objectwidth = undefined
  @objectheight = undefined

  @canvas = undefined
  @context = undefined
  @texture = undefined
  @geometroy = undefined

  # private variable
  RAD = Math.PI / 180.0

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
    @object = if (arr['object']?) then arr['object'] else undefined
    @width = if (arr['width']?) then arr['width'] else 32
    @height = if (arr['height']?) then arr['height'] else 32
    @orgscale = if (arr['orgscale']?) then arr['orgscale'] else 1.0
    @xscale = if (arr['xscale']?) then arr['xscale'] else 1.0
    @yscale = if (arr['yscale']?) then arr['yscale'] else 1.0
    @zscale = if (arr['zscale']?) then arr['zscale'] else 1.0
    @rotate = if (arr['rotate']?) then arr['rotate'] else 0.0
    @xrotate = if (arr['xrotate']?) then arr['xrotate'] else undefined
    @yrotate = if (arr['yrotate']?) then arr['yrotate'] else undefined
    @zrotate = if (arr['zrotate']?) then arr['zrotate'] else undefined
    @xsegments = if (arr['xsegments']?) then arr['xsegments'] else 1
    @ysegments = if (arr['ysegments']?) then arr['ysegments'] else 1
    @color = if (arr['color']?) then arr['color'] else '0x000000'
    @patternList = if (arr['patternList']?) then arr['patternList'] else [[100, [0]]]
    @patternNum = if (arr['patternNum']?) then arr['patternNum'] else 0
    @spriteID = if (arr['spriteID']?) then arr['spriteID'] else undefined

    switch (@object.type)
      #========================================================================
      # 画像
      #========================================================================
      when 'image'
        image = @object.object
        # texture width
        @objectwidth = image.width
        # texture height
        @objectheight = image.height

        @animetime = new Date().getTime()
        spwnum = Math.floor(@objectwidth / @width)
        sphnum = Math.floor(@objectheight / @height)
        @maxFrame = (spwnum * sphnum) - 1

        @canvas = document.createElement("canvas")

        @canvas.width = @objectwidth
        @canvas.height = @objectheight

        pattern = @patternList[@patternNum][1]
        index = pattern[@frameIndex]
        wnum = Math.floor(@objectwidth / @width)
        hnum = Math.floor(@objectheight / @height)
        if (index > @maxFrame)
          num = index % @maxFrame
        startx = (index % wnum) * @width
        starty = ((hnum - (Math.floor(index / wnum))) - 1) * @height

        @context = @canvas.getContext("2d")
        @context.drawImage(image, 0, 0, @objectwidth, @objectheight, 0, 0, @objectwidth, @objectheight)

        @texture = new THREE.CanvasTexture(@canvas)
        @texture.minFilter = THREE.LinearFilter
        @texture.repeat.set(@width / @objectwidth, @height / @objectheight)

        @texture.offset.x = startx / @objectwidth
        @texture.offset.y = starty / @objectheight

        @geometry = new THREE.PlaneGeometry(@width * @orgscale * @xscale, @height * @orgscale * @yscale)
        material = new THREE.MeshBasicMaterial
          map:@texture
          transparent:true
        @mesh = new THREE.Mesh(@geometry, material)
        @mesh.rotation.z = @rotate * RAD
        @texture.needsUpdate = true

      #========================================================================
      # primitive
      #========================================================================
      when 'primitive'
        type = @object.object
        switch (type)
          when 'plane'
            @geometry = new THREE.PlaneGeometry(@width * @orgscale * @xscale, @height * @orgscale * @yscale, @xsegments, @ysegments)
            #material = new THREE.MeshPhongMaterial
            material = new THREE.MeshLambertMaterial
              color: parseInt(@color, 16)
              specular: 0x999999
              shininess: 60
              side: THREE.DoubleSide
              transparent:true
            @mesh = new THREE.Mesh(@geometry, material)
            @mesh.castShadow = true
            @mesh.receiveShadow = true
            @mesh.position.set(@x, @y, @z)
            @mesh.rotation.x = @xrotate * RAD if (@xrotate?)
            @mesh.rotation.y = @yrotate * RAD if (@yrotate?)
            @mesh.rotation.z = @zrotate * RAD if (@zrotate?)
          when 'cube'
            @geometry = new THREE.BoxGeometry(@orgscale * @xscale, @orgscale * @yscale, @orgscale * @zscale)
            material = new THREE.MeshLambertMaterial
              color: parseInt(@color, 16)
              transparent:true
            @mesh = new THREE.Mesh(@geometry, material)
            @mesh.castShadow = true
            @mesh.receiveShadow = true
            @mesh.position.set(@x, @y, @z)
            @mesh.rotation.x = @xrotate * RAD if (@xrotate?)
            @mesh.rotation.y = @yrotate * RAD if (@yrotate?)
            @mesh.rotation.z = @zrotate * RAD if (@zrotate?)


      #========================================================================
      # Collada
      #========================================================================
      when 'collada'
        @mesh = @object.object.clone()
        @mesh.castShadow = true
        @mesh.receiveShadow = true
        @mesh.position.set(@x, @y, @z)
        @mesh.scale.set(@xscale * @orgscale, @yscale * @orgscale, @zscale * @orgscale)
        @mesh.rotation.x = @xrotate * RAD if (@xrotate?)
        @mesh.rotation.y = @yrotate * RAD if (@yrotate?)
        @mesh.rotation.z = @zrotate * RAD if (@zrotate?)

  setCharacterPicture:(@frameIndex)->
    pattern = @patternList[@patternNum][1]
    index = pattern[@frameIndex]
    wnum = Math.floor(@objectwidth / @width)
    hnum = Math.floor(@objectheight / @height)
    if (index > @maxFrame)
      num = index % @maxFrame
    startx = (index % wnum) * @width
    starty = (((hnum - (Math.floor(index / wnum))) - 1) * @height) - 1
    @texture.offset.x = (startx / @objectwidth)
    @texture.offset.y = (starty / @objectheight)


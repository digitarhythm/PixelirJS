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
  @LIGHTS = undefined
  @STARTTIME = undefined
  @LAPSEDTIME = undefined
  @FPSAVR = undefined
  @FPSINTERVAL = undefined
  @FPS = undefined
  @SPRITE_LIST = undefined
  @BG_COLOR = undefined
  @STAGE_COLOR = undefined
  @BASE = undefined
  @RENDERER = undefined
  @CAMERA2D = undefined
  @CAMERA3D = undefined
  @STATS = undefined
  @PIXELRATIO = undefined
  @COLLADA_LOADER = undefined

  # private variable
  RAD = Math.PI / 180.0

  constructor:(arr)->
    if (!arr?)
      arr = []

    # requestAnimationFrame
    requestAnimationFrame = window.requestAnimationFrame ||
                window.mozRequestAnimationFrame ||
                window.webkitRequestAnimationFrame ||
                window.msRequestAnimationFrame
    window.requestAnimationFrame = requestAnimationFrame

    # get size
    @BROWSER_WIDTH = window.innerWidth
    @BROWSER_HEIGHT = window.innerHeight
    @SCREEN_WIDTH = if (arr['screen_width']?) then arr['screen_width'] else @BROWSER_WIDTH
    @SCREEN_HEIGHT = if (arr['screen_height']?) then arr['screen_height'] else @BROWSER_HEIGHT
    @LAYERS = []

    # sprite list init
    @SPRITE_LIST = {}

    # Lapsed time init
    @STARTTIME = new Date().getTime()
    @LAPSEDTIME = 0.0

    # set canvas parameter
    @FPS = if (arr['fps']?) then arr['fps'] else 60
    @BG_COLOR = if (arr['bg_color']?) then arr['bg_color'] else "gray"
    @STAGE_COLOR = if (arr['stage_color']?) then arr['stage_color'] else "black"

    # Collada Loader
    @COLLADA_LOADER = new THREE.ColladaLoader()
    @COLLADA_LOADER.options.convertUpAxis = true

    # renderer initialize
    @__initRenderer
      bg_color: @BG_COLOR

#****************************************************************************
#****************************************************************************
#****************************************************************************
#
# enterframe
#
#****************************************************************************
#****************************************************************************
#****************************************************************************

  #****************************************************************************
  # enter frame process
  #****************************************************************************
  enterframe:(func)->
    @__behavior(func)

  #****************************************************************************
  # behavior process
  #****************************************************************************
  __behavior:(func)->
    @STATS.begin()

    # animation frame
    setTimeout =>
      window.requestAnimationFrame =>
        @__behavior(func)

      # Lapsed time
      @LAPSEDTIME = new Date().getTime() - @STARTTIME

      # claer sreen
      @RENDERER.clear()

      # character draw
      for id, sprite of @SPRITE_LIST
        if (sprite.object.type == 'image')
          sprite.ys += sprite.gravity
        else
          sprite.ys -= sprite.gravity
        sprite.x += sprite.xs
        sprite.y += sprite.ys
        sprite.z += sprite.zs
        @__drawSprite(sprite)

      # character move
      func()

      # scene transport to screen
      @RENDERER.clearDepth()
      @RENDERER.render(@LAYERS.background, @CAMERA2D)
      @RENDERER.clearDepth()
      @RENDERER.render(@LAYERS.layer3d, @CAMERA3D)
      if (@LAYERS.length > 0)
        for layer in @LAYERS
          @RENDERER.clearDepth()
          @RENDERER.render(layer, @CAMERA2D)

    , @FPSINTERVAL

    @STATS.end()


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
  addSprite:(sprite, layer = "background")->
    switch (sprite.object.type)
      when 'image'
        if (layer == "background")
          scene = @LAYERS.background
        else
          if (layer >= @LAYERS.length)
            return
          scene = @LAYERS[layer]
      when 'collada', 'primitive'
        scene = @LAYERS.layer3d

    sprite.layer = layer
    @SPRITE_LIST[sprite.spriteID] = sprite
    scene.add(sprite.mesh)

  #========================================================================
  # remove sprite
  #========================================================================
  removeSprite:(sprite)->
    if (@SPRITE_LIST[sprite.spriteID]?)
      delete @SPRITE_LIST[sprite.spriteID]

  #========================================================================
  # draw sprite
  #========================================================================
  __drawSprite:(sprite)->
    switch (sprite.object.type)
      when 'image'
        x = parseInt(-(@SCREEN_WIDTH / 2.0) + sprite.x)
        y = parseInt((@SCREEN_HEIGHT / 2.0) - sprite.y)
        z = 0

        patternlist = sprite.patternList[sprite.patternNum]
        animetime = patternlist[0]
        animelist = patternlist[1]
        if (animelist.length > 1)
          nowepoch = new Date().getTime()
          frameindex = sprite.frameIndex
          if (nowepoch > sprite.animetime + animetime)
            sprite.animetime = new Date().getTime()
            frameindex++
            if (frameindex >= animelist.length)
              frameindex = 0
            sprite.frameIndex = frameindex
            sprite.setCharacterPicture(frameindex)
        if (sprite.rotate < 0)
          rot = 360 + (sprite.rotate % 360) * RAD
        else
          rot = (sprite.rotate % 360.0) * RAD
        sprite.mesh.rotation.z = rot
      when 'collada', 'primitive'
        x = sprite.x
        y = sprite.y
        z = sprite.z
        if (sprite.xrotate?)
          rx = (sprite.xrotate % 360.0) * RAD
          sprite.mesh.rotation.x = rx
        if (sprite.yrotate?)
          ry = (sprite.yrotate % 360.0) * RAD
          sprite.mesh.rotation.y = ry
        if (sprite.zrotate?)
          rz = (sprite.zrotate % 360.0) * RAD
          sprite.mesh.rotation.z = rz

    sprite.mesh.position.set(x, y, z)

  #========================================================================
  # Object data preload
  #========================================================================
  __loadObjects:(assets_list, func)->
    list = assets_list.shift(1)
    name = list[0]
    src = list[1]
    if (src.match(/(\.png|\.jpg)$/))
      img = new Image()
      img.src = src
      img.onload = =>
        @ASSETS[name] =
          type: 'image'
          object: img
        if (assets_list.length > 0)
          @__loadObjects(assets_list, func)
        else
          func(@ASSETS)
    else if (src.match(/\.dae$/))
      @COLLADA_LOADER.load src, (model) =>
        scene = model.scene
        @ASSETS[name] =
          type: 'collada'
          object: scene
        if (assets_list.length > 0)
          @__loadObjects(assets_list, func)
        else
          func(@ASSETS)
    else
      func(@ASSETS)

  #========================================================================
  # preload media file
  #========================================================================
  preload:(resources, func)->
    if (!resources?)
      return undefined
    @ASSETS = {}
    assets_list = resources.concat()
    @__loadObjects(assets_list, func)

  #========================================================================
  # create new sprite
  #========================================================================
  newSprite:(arr)->
    x = if (arr['x']?) then arr['x'] else 0.0
    y = if (arr['y']?) then arr['y'] else 0.0
    z = if (arr['z']?) then arr['z'] else 0.0
    xs = if (arr['xs']?) then arr['xs'] else 0.0
    ys = if (arr['ys']?) then arr['ys'] else 0.0
    zs = if (arr['zs']?) then arr['zs'] else 0.0
    frameIndex = if (arr['frameIndex']?) then arr['frameIndex'] else 0
    hidden = if (arr['hidden']?) then arr['hidden'] else false
    object = if (arr['object']?) then arr['object'] else undefined
    width = if (arr['width']?) then arr['width'] else 32.0
    height = if (arr['height']?) then arr['height'] else 32.0
    orgscale = if (arr['orgscale']?) then arr['orgscale'] else 1.0
    rotate = if (arr['rotate']?) then arr['rotate'] else 0.0
    xrotate = if (arr['xrotate']?) then arr['xrotate'] else undefined
    yrotate = if (arr['yrotate']?) then arr['yrotate'] else undefined
    zrotate = if (arr['zrotate']?) then arr['zrotate'] else undefined
    xscale = if (arr['xscale']?) then arr['xscale'] else 1.0
    yscale = if (arr['yscale']?) then arr['yscale'] else 1.0
    zscale = if (arr['zscale']?) then arr['zscale'] else 1.0
    xsegments = if (arr['xsegments']?) then arr['xsegments'] else 1
    ysegments = if (arr['ysegments']?) then arr['ysegments'] else 1
    color = if (arr['color']?) then arr['color'] else '0x000000'
    rotate = if (arr['rotate']?) then arr['rotate'] else 0.0
    gravity = if (arr['gravity']?) then arr['gravity'] else 0.0
    patternList = if (arr['patternList']?) then arr['patternList'] else [[100, [0]]]
    patternNum = if (arr['patternNum']?) then arr['patternNum'] else 0

    # object is primitive
    if (typeof(object) == 'string')
      match = object.match(/^primitive_(.*)$/)
      if (match?)
        object =
          type: 'primitive'
          object: match[1]
          xsegments: xsegments
          ysegments: ysegments
          color: color

    id = @__getUniqueID()
    sprite = new pixelir_sprite
      x: parseFloat(x)
      y: parseFloat(y)
      z: parseFloat(z)
      xs: parseFloat(xs)
      ys: parseFloat(ys)
      zs: parseFloat(zs)
      frameIndex: frameIndex
      hidden: hidden
      object: object
      width: width
      height: height
      orgscale: orgscale
      rotate: rotate
      xrotate: xrotate
      yrotate: yrotate
      zrotate: zrotate
      xscale: xscale
      yscale: yscale
      zscale: zscale
      rotate: rotate
      gravity: gravity
      color: color
      patternList: patternList
      patternNum: patternNum
      spriteID: id
    return sprite


#****************************************************************************
#****************************************************************************
#****************************************************************************
#
# Layer
#
#****************************************************************************
#****************************************************************************
#****************************************************************************

  #************************************************************************
  # create new layer
  #************************************************************************
  createLayer:(arr = [])->
    hidden = if (arr['hidden']?) then arr['hidden'] else false

    scene = new THREE.Scene()
    @LAYERS.push(scene)
    return (@LAYERS.length) - 1

  #************************************************************************
  # remove layer
  #************************************************************************
  removeLayer:(num)->
    if (num < 0 || @LAYERS.length <= num)
      return
    @LAYERS.splice(num, 1)

  #************************************************************************
  # clear layer
  #************************************************************************
  clearLayer:(num)->

  #************************************************************************
  # get unique ID
  #************************************************************************
  __getUniqueID:->
    S4 = ->
      return (((1+Math.random())*0x10000)|0).toString(16).substring(1).toString()
    return (S4()+S4()+"-"+S4()+"-"+S4()+"-"+S4()+"-"+S4()+S4()+S4())

  #========================================================================
  # Webcanvas canvas init
  #========================================================================
  __initRenderer:(arr = {})->
    bg_color = if (arr['bg_color']?) then arr['bg_color'] else "gray"

    # set background color of BODY
    body = document.body
    if (bg_color?)
      body.style.background = bg_color

    # set fullscreen
    ratio = @SCREEN_WIDTH / @SCREEN_HEIGHT
    _CANVAS_WIDTH = @BROWSER_WIDTH
    _CANVAS_HEIGHT = @BROWSER_WIDTH / ratio
    diff_x = 0
    diff_y = (@BROWSER_HEIGHT - _CANVAS_HEIGHT) / 2
    if (_CANVAS_HEIGHT > @BROWSER_HEIGHT)
      _CANVAS_WIDTH = @BROWSER_HEIGHT * ratio
      _CANVAS_HEIGHT = @BROWSER_HEIGHT
      diff_x = (@BROWSER_WIDTH - _CANVAS_WIDTH) / 2
      diff_y = 0

    # create base DIV
    @BASE = document.createElement("div")
    @BASE.style.position = "absolute"
    @BASE.style.background = @STAGE_COLOR
    @BASE.style.overflow = "hidden"
    @BASE.style.width = _CANVAS_WIDTH+"px"
    @BASE.style.height = _CANVAS_HEIGHT+"px"
    @BASE.style.left = diff_x+"px"
    @BASE.style.top = diff_y+"px"

    @STATS = new Stats()
    @STATS.showPanel(0)

    body = document.body
    body.appendChild(@BASE)
    body.appendChild(@STATS.domElement)

    #============================================================================
    # renderer setup
    #============================================================================
    @PIXELRATIO = `window.devicePixelRatio ? window.devicePixelRatio : 1`

    if (@__detector())
      @RENDERER = new THREE.WebGLRenderer({alpha:true, antialias: true})
    else
      @RENDERER = new THREE.CanvasRenderer({alpha:true, antialias: true})
    #@RENDERER = new THREE.WebGLRenderer({alpha:true, antialias: true})

    @RENDERER.autoClear = false
    @RENDERER.shadowMap.enabled = true
    @RENDERER.shadowMap.type = THREE.PCFSoftShadowMap
    @RENDERER.setClearColor(0x000000, 0)
    @RENDERER.setSize(@SCREEN_WIDTH, @SCREEN_HEIGHT)
    @RENDERER.setPixelRatio(@PIXELRATIO)

    @RENDERER.domElement.style.position = "absolute"
    @RENDERER.domElement.style.width = "100%"
    @RENDERER.domElement.style.height = "100%"
    @RENDERER.domElement.style.left = "0px"
    @RENDERER.domElement.style.top = "0px"

    @BASE.appendChild(@RENDERER.domElement)

    @CAMERA2D = new THREE.OrthographicCamera(@SCREEN_WIDTH/-2, @SCREEN_WIDTH/2, @SCREEN_HEIGHT/2, @SCREEN_HEIGHT/-2, -10, 10)
    @CAMERA2D.position.set(0, 0, 1)
    @CAMERA3D = new THREE.PerspectiveCamera(90, @SCREEN_WIDTH / @SCREEN_HEIGHT, 1, 100000)
    @CAMERA3D.position.set(0, 100, 100)
    @CAMERA3D.lookAt(0, 0, 0)

    #============================================================================
    # 3D initialize
    #============================================================================
    ambientlight = new THREE.AmbientLight(0xffffff, 0.5)
    ambientlight.position.set(100000, 100000, 100000)

    directionallight = new THREE.DirectionalLight(0xffffff, 0.5)
    directionallight.position.set(100000, 100000, 100000)
    directionallight.castShadow = true
    directionallight.shadow.mapSize.width = 2048
    directionallight.shadow.mapSize.height = 2048
    directionallight.shadow.camera.near = 0.5
    directionallight.shadow.camera.far = 500

    spotlight = new THREE.SpotLight(0xffffff)
    #spotlight = new THREE.SpotLight(0xFFFFFF, 2, 100, Math.PI / 4, 1)
    spotlight.shadow.mapSize.width = 2048
    spotlight.shadow.mapSize.height = 2048
    spotlight.position.set(0, 1000, 0)
    spotlight.target.position.set(0, 0, 0)
    spotlight.shadowCameraVisible = true

    @LIGHTS =
      ambient: ambientlight
      directional: directionallight
      spotlight: spotlight

    @LAYERS.layer3d = new THREE.Scene()
    #@LAYERS.layer3d.add(ambientlight)
    @LAYERS.layer3d.add(directionallight)
    @LAYERS.layer3d.add(spotlight)

    ambientlight.castShadow = true
    directionallight.castShadow = true
    spotlight.castShadow = true

    @LAYERS.background = new THREE.Scene()

  #============================================================================
  # WebGL detector
  #============================================================================
  __detector:->
      try
        canvas = document.createElement('canvas')
        webGLContext = canvas.getContext("webgl") || canvas.getContext("experimental-webgl")
        ret = !!(window.WebGLRenderingContext && webGLContext && webGLContext.getShaderPrecisionFormat)
      catch e
        ret = false
      return ret


RAD = Math.PI / 180

onload = ->
  console.clear()
  width = 1920
  height = 1080
  fps = 60
  cube = undefined

  app = new pixelir_core
    screen_width: width
    screen_height: height
    bg_color: "gray"
    stage_color: "black"
    fps: fps

  resources = [
    ['chara1', 'objects/chara1.png']
    ['chara0', 'objects/chara0.png']
    ['aircraft', 'objects/E-45-Aircraft/Aircraft_dae.dae']
    ['droid', 'objects/droid.dae']
    ['negimiku', 'objects/negimiku.dae']
  ]

  ret = app.createLayer()

  # リソースデータをプリロードする
  app.preload resources, (assets) ->
    cube = app.newSprite
      x: 0
      y: 1000
      z: 0
      orgscale: 30
      object: 'primitive_cube'
      color: '0xff9000'
      xscale: 30
      yscale: 30
      zscale: 30
      xs: (random(8) - 4) * 10
      zs: (random(8) - 4) * 10
      gravity: -10
    app.addSprite(cube)

    ground = app.newSprite
      y: -100
      orgscale: 300
      object: 'primitive_plane'
      color: '0x0090ff'
      xrotate: 90
    app.addSprite(ground)

    sprites = []
    for i in [0...30]
      kind = random(1)
      img = assets[resources[kind][0]]
      size = (random(5) + 5) / 1
      sprite = app.newSprite
        x: random(width)
        y: random(90)+10
        xs: random(2) + 2
        object: img
        xscale: size
        yscale: size
        gravity: (random(9)+1)/10
        width: 32
        height: 32
        patternNum: random(2)
        patternList: [
          [100, [10, 11, 10, 12]]
          [100, [5, 6, 5, 7]]
          [100, [0, 1, 0, 2]]
        ]
      if (kind == 0)
        app.addSprite(sprite, 0)
      else
        app.addSprite(sprite)
      sprites.push(sprite)

    for i in [0...100]
      kind = random(1)
      scale = (random(13) + 3) / 3
      sprite = app.newSprite
        x: random(width*2) - width
        y: random(50)+70
        z: random(width*8) - width*4
        xs: (random(8) - 4) * 2
        zs: (random(8) - 4) * 2
        gravity: 3
        orgscale: ((kind * 120) + 10) * 1
        xscale: scale
        yscale: scale
        zscale: scale
        xrotate: 0
        yrotate: 0
        zrotate: 0
        object: if (kind == 0) then assets['negimiku'] else assets['droid']
      app.addSprite(sprite)
      sprites.push(sprite)

    camera_radius = 0
    camera_x = 5000
    camera_y = 5000
    camera_z = 5000
    app.CAMERA3D.position.set(camera_x, camera_y, camera_z)
    app.enterframe ->
      #camera_x = Math.cos(camera_radius * RAD) * 5000
      #camera_y = 3000
      #camera_z = Math.sin(camera_radius * RAD) * 5000
      #camera_radius = ++camera_radius % 360
      app.CAMERA3D.lookAt(cube.x, cube.y, cube.z)
      for sprite in sprites
        if (sprite.object.type == 'image')
          sprite.rotate--
          if (sprite.x < 0)
            sprite.x = width
          if (sprite.x > width)
            sprite.x = 0
          if (sprite.y > height-(sprite.height/2))
            sprite.y = height-(sprite.height/2)
            sprite.ys *= -1
        else
          sprite.xrotate++
          sprite.yrotate++
          sprite.zrotate++
          if (sprite.x < -width*3)
            sprite.x = width*3
          if (sprite.x > width*3)
            sprite.x = -width*3
          if (sprite.z < -width*6)
            sprite.z = width*6
          if (sprite.z > width*6)
            sprite.z = -width*6
          if (sprite.y < 0)
            sprite.y = 0
            sprite.ys = (random(64)+32)

      if (cube.x < -width*3)
        cube.x = -width*3
        cube.xs *= -1
      if (cube.x > width*3)
        cube.x = width*3
        cube.xs *= -1
      if (cube.z < -width*3)
        cube.z = -width*3
        cube.zs *= -1
      if (cube.z > width*3)
        cube.z = width*3
        cube.zs *= -1
      if (cube.y < 0)
        cube.y = 0
        cube.ys = (random(256)+32)


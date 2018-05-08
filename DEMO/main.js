// Generated by CoffeeScript 2.2.2
var RAD, onload;

RAD = Math.PI / 180;

onload = function() {
  var app, cube, fps, height, resources, ret, width;
  console.clear();
  width = 1920;
  height = 1080;
  fps = 60;
  cube = void 0;
  app = new pixelir_core({
    screen_width: width,
    screen_height: height,
    bg_color: "gray",
    stage_color: "black",
    fps: fps
  });
  resources = [['chara1', 'objects/chara1.png'], ['chara0', 'objects/chara0.png'], ['aircraft', 'objects/E-45-Aircraft/Aircraft_dae.dae'], ['droid', 'objects/droid.dae'], ['negimiku', 'objects/negimiku.dae']];
  ret = app.createLayer();
  // リソースデータをプリロードする
  return app.preload(resources, function(assets) {
    var camera_radius, camera_x, camera_y, camera_z, ground, i, img, j, k, kind, scale, size, sprite, sprites;
    cube = app.newSprite({
      x: 0,
      y: 1000,
      z: 0,
      orgscale: 30,
      object: 'primitive_cube',
      color: '0xff9000',
      xscale: 30,
      yscale: 30,
      zscale: 30,
      xs: (random(8) - 4) * 10,
      zs: (random(8) - 4) * 10,
      gravity: -10
    });
    app.addSprite(cube);
    ground = app.newSprite({
      y: -100,
      orgscale: 300,
      object: 'primitive_plane',
      color: '0x0090ff',
      xrotate: 90
    });
    app.addSprite(ground);
    sprites = [];
    for (i = j = 0; j < 30; i = ++j) {
      kind = random(1);
      img = assets[resources[kind][0]];
      size = (random(5) + 5) / 1;
      sprite = app.newSprite({
        x: random(width),
        y: random(90) + 10,
        xs: random(2) + 2,
        object: img,
        xscale: size,
        yscale: size,
        gravity: (random(9) + 1) / 10,
        width: 32,
        height: 32,
        patternNum: random(2),
        patternList: [[100, [10, 11, 10, 12]], [100, [5, 6, 5, 7]], [100, [0, 1, 0, 2]]]
      });
      if (kind === 0) {
        app.addSprite(sprite, 0);
      } else {
        app.addSprite(sprite);
      }
      sprites.push(sprite);
    }
    for (i = k = 0; k < 100; i = ++k) {
      kind = random(1);
      scale = (random(13) + 3) / 3;
      sprite = app.newSprite({
        x: random(width * 2) - width,
        y: random(50) + 70,
        z: random(width * 8) - width * 4,
        xs: (random(8) - 4) * 2,
        zs: (random(8) - 4) * 2,
        gravity: 3,
        orgscale: ((kind * 120) + 10) * 1,
        xscale: scale,
        yscale: scale,
        zscale: scale,
        xrotate: 0,
        yrotate: 0,
        zrotate: 0,
        object: kind === 0 ? assets['negimiku'] : assets['droid']
      });
      app.addSprite(sprite);
      sprites.push(sprite);
    }
    camera_radius = 0;
    camera_x = 5000;
    camera_y = 5000;
    camera_z = 5000;
    app.CAMERA3D.position.set(camera_x, camera_y, camera_z);
    return app.enterframe(function() {
      var l, len;
      //camera_x = Math.cos(camera_radius * RAD) * 5000
      //camera_y = 3000
      //camera_z = Math.sin(camera_radius * RAD) * 5000
      //camera_radius = ++camera_radius % 360
      app.CAMERA3D.lookAt(cube.x, cube.y, cube.z);
      for (l = 0, len = sprites.length; l < len; l++) {
        sprite = sprites[l];
        if (sprite.object.type === 'image') {
          sprite.rotate--;
          if (sprite.x < 0) {
            sprite.x = width;
          }
          if (sprite.x > width) {
            sprite.x = 0;
          }
          if (sprite.y > height - (sprite.height / 2)) {
            sprite.y = height - (sprite.height / 2);
            sprite.ys *= -1;
          }
        } else {
          sprite.xrotate++;
          sprite.yrotate++;
          sprite.zrotate++;
          if (sprite.x < -width * 3) {
            sprite.x = width * 3;
          }
          if (sprite.x > width * 3) {
            sprite.x = -width * 3;
          }
          if (sprite.z < -width * 6) {
            sprite.z = width * 6;
          }
          if (sprite.z > width * 6) {
            sprite.z = -width * 6;
          }
          if (sprite.y < 0) {
            sprite.y = 0;
            sprite.ys = random(64) + 32;
          }
        }
      }
      if (cube.x < -width * 3) {
        cube.x = -width * 3;
        cube.xs *= -1;
      }
      if (cube.x > width * 3) {
        cube.x = width * 3;
        cube.xs *= -1;
      }
      if (cube.z < -width * 3) {
        cube.z = -width * 3;
        cube.zs *= -1;
      }
      if (cube.z > width * 3) {
        cube.z = width * 3;
        cube.zs *= -1;
      }
      if (cube.y < 0) {
        cube.y = 0;
        return cube.ys = random(256) + 32;
      }
    });
  });
};

//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoibWFpbi5qcyIsInNvdXJjZVJvb3QiOiIuLiIsInNvdXJjZXMiOlsiREVNTy9tYWluLmNvZmZlZSJdLCJuYW1lcyI6W10sIm1hcHBpbmdzIjoiO0FBQUEsSUFBQSxHQUFBLEVBQUE7O0FBQUEsR0FBQSxHQUFNLElBQUksQ0FBQyxFQUFMLEdBQVU7O0FBRWhCLE1BQUEsR0FBUyxRQUFBLENBQUEsQ0FBQTtBQUNQLE1BQUEsR0FBQSxFQUFBLElBQUEsRUFBQSxHQUFBLEVBQUEsTUFBQSxFQUFBLFNBQUEsRUFBQSxHQUFBLEVBQUE7RUFBQSxPQUFPLENBQUMsS0FBUixDQUFBO0VBQ0EsS0FBQSxHQUFRO0VBQ1IsTUFBQSxHQUFTO0VBQ1QsR0FBQSxHQUFNO0VBQ04sSUFBQSxHQUFPO0VBRVAsR0FBQSxHQUFNLElBQUksWUFBSixDQUNKO0lBQUEsWUFBQSxFQUFjLEtBQWQ7SUFDQSxhQUFBLEVBQWUsTUFEZjtJQUVBLFFBQUEsRUFBVSxNQUZWO0lBR0EsV0FBQSxFQUFhLE9BSGI7SUFJQSxHQUFBLEVBQUs7RUFKTCxDQURJO0VBT04sU0FBQSxHQUFZLENBQ1YsQ0FBQyxRQUFELEVBQVcsb0JBQVgsQ0FEVSxFQUVWLENBQUMsUUFBRCxFQUFXLG9CQUFYLENBRlUsRUFHVixDQUFDLFVBQUQsRUFBYSx3Q0FBYixDQUhVLEVBSVYsQ0FBQyxPQUFELEVBQVUsbUJBQVYsQ0FKVSxFQUtWLENBQUMsVUFBRCxFQUFhLHNCQUFiLENBTFU7RUFRWixHQUFBLEdBQU0sR0FBRyxDQUFDLFdBQUosQ0FBQSxFQXJCTjs7U0F3QkEsR0FBRyxDQUFDLE9BQUosQ0FBWSxTQUFaLEVBQXVCLFFBQUEsQ0FBQyxNQUFELENBQUE7QUFDckIsUUFBQSxhQUFBLEVBQUEsUUFBQSxFQUFBLFFBQUEsRUFBQSxRQUFBLEVBQUEsTUFBQSxFQUFBLENBQUEsRUFBQSxHQUFBLEVBQUEsQ0FBQSxFQUFBLENBQUEsRUFBQSxJQUFBLEVBQUEsS0FBQSxFQUFBLElBQUEsRUFBQSxNQUFBLEVBQUE7SUFBQSxJQUFB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RjtNQTBCQSxJQUFJLElBQUksQ0FBQyxDQUFMLEdBQVMsQ0FBQyxLQUFELEdBQU8sQ0FBcEI7UUFDRSxJQUFJLENBQUMsQ0FBTCxHQUFTLENBQUMsS0FBRCxHQUFPO1FBQ2hCLElBQUksQ0FBQyxFQUFMLElBQVcsQ0FBQyxFQUZkOztNQUdBLElBQUksSUFBSSxDQUFDLENBQUwsR0FBUyxLQUFBLEdBQU0sQ0FBbkI7UUFDRSxJQUFJLENBQUMsQ0FBTCxHQUFTLEtBQUEsR0FBTTtRQUNmLElBQUksQ0FBQyxFQUFMLElBQVcsQ0FBQyxFQUZkOztNQUdBLElBQUksSUFBSSxDQUFDLENBQUwsR0FBUyxDQUFDLEtBQUQsR0FBTyxDQUFwQjtRQUNFLElBQUksQ0FBQyxDQUFMLEdBQVMsQ0FBQyxLQUFELEdBQU87UUFDaEIsSUFBSSxDQUFDLEVBQUwsSUFBVyxDQUFDLEVBRmQ7O01BR0EsSUFBSSxJQUFJLENBQUMsQ0FBTCxHQUFTLEtBQUEsR0FBTSxDQUFuQjtRQUNFLElBQUksQ0FBQyxDQUFMLEdBQVMsS0FBQSxHQUFNO1FBQ2YsSUFBSSxDQUFDLEVBQUwsSUFBVyxDQUFDLEVBRmQ7O01BR0EsSUFBSSxJQUFJLENBQUMsQ0FBTCxHQUFTLENBQWI7UUFDRSxJQUFJLENBQUMsQ0FBTCxHQUFTO2VBQ1QsSUFBSSxDQUFDLEVBQUwsR0FBVyxNQUFBLENBQU8sR0FBUCxDQUFBLEdBQVksR0FGekI7O0lBNUNhLENBQWY7RUE3RXFCLENBQXZCO0FBekJPIiwic291cmNlc0NvbnRlbnQiOlsiUkFEID0gTWF0aC5QSSAvIDE4MFxuXG5vbmxvYWQgPSAtPlxuICBjb25zb2xlLmNsZWFyKClcbiAgd2lkdGggPSAxOTIwXG4gIGhlaWdodCA9IDEwODBcbiAgZnBzID0gNjBcbiAgY3ViZSA9IHVuZGVmaW5lZFxuXG4gIGFwcCA9IG5ldyBwaXhlbGlyX2NvcmVcbiAgICBzY3JlZW5fd2lkdGg6IHdpZHRoXG4gICAgc2NyZWVuX2hlaWdodDogaGVpZ2h0XG4gICAgYmdfY29sb3I6IFwiZ3JheVwiXG4gICAgc3RhZ2VfY29sb3I6IFwiYmxhY2tcIlxuICAgIGZwczogZnBzXG5cbiAgcmVzb3VyY2VzID0gW1xuICAgIFsnY2hhcmExJywgJ29iamVjdHMvY2hhcmExLnBuZyddXG4gICAgWydjaGFyYTAnLCAnb2JqZWN0cy9jaGFyYTAucG5nJ11cbiAgICBbJ2FpcmNyYWZ0JywgJ29iamVjdHMvRS00NS1BaXJjcmFmdC9BaXJjcmFmdF9kYWUuZGFlJ11cbiAgICBbJ2Ryb2lkJywgJ29iamVjdHMvZHJvaWQuZGFlJ11cbiAgICBbJ25lZ2ltaWt1JywgJ29iamVjdHMvbmVnaW1pa3UuZGFlJ11cbiAgXVxuXG4gIHJldCA9IGFwcC5jcmVhdGVMYXllcigpXG5cbiAgIyDjg6rjgr3jg7zjgrnjg4fjg7zjgr/jgpLjg5fjg6rjg63jg7zjg4njgZnjgotcbiAgYXBwLnByZWxvYWQgcmVzb3VyY2VzLCAoYXNzZXRzKSAtPlxuICAgIGN1YmUgPSBhcHAubmV3U3ByaXRlXG4gICAgICB4OiAwXG4gICAgICB5OiAxMDAwXG4gICAgICB6OiAwXG4gICAgICBvcmdzY2FsZTogMzBcbiAgICAgIG9iamVjdDogJ3ByaW1pdGl2ZV9jdWJlJ1xuICAgICAgY29sb3I6ICcweGZmOTAwMCdcbiAgICAgIHhzY2FsZTogMzBcbiAgICAgIHlzY2FsZTogMzBcbiAgICAgIHpzY2FsZTogMzBcbiAgICAgIHhzOiAocmFuZG9tKDgpIC0gNCkgKiAxMFxuICAgICAgenM6IChyYW5kb20oOCkgLSA0KSAqIDEwXG4gICAgICBncmF2aXR5OiAtMTBcbiAgICBhcHAuYWRkU3ByaXRlKGN1YmUpXG5cbiAgICBncm91bmQgPSBhcHAubmV3U3ByaXRlXG4gICAgICB5OiAtMTAwXG4gICAgICBvcmdzY2FsZTogMzAwXG4gICAgICBvYmplY3Q6ICdwcmltaXRpdmVfcGxhbmUnXG4gICAgICBjb2xvcjogJzB4MDA5MGZmJ1xuICAgICAgeHJvdGF0ZTogOTBcbiAgICBhcHAuYWRkU3ByaXRlKGdyb3VuZClcblxuICAgIHNwcml0ZXMgPSBbXVxuICAgIGZvciBpIGluIFswLi4uMzBdXG4gICAgICBraW5kID0gcmFuZG9tKDEpXG4gICAgICBpbWcgPSBhc3NldHNbcmVzb3VyY2VzW2tpbmRdWzBdXVxuICAgICAgc2l6ZSA9IChyYW5kb20oNSkgKyA1KSAvIDFcbiAgICAgIHNwcml0ZSA9IGFwcC5uZXdTcHJpdGVcbiAgICAgICAgeDogcmFuZG9tKHdpZHRoKVxuICAgICAgICB5OiByYW5kb20oOTApKzEwXG4gICAgICAgIHhzOiByYW5kb20oMikgKyAyXG4gICAgICAgIG9iamVjdDogaW1nXG4gICAgICAgIHhzY2FsZTogc2l6ZVxuICAgICAgICB5c2NhbGU6IHNpemVcbiAgICAgICAgZ3Jhdml0eTogKHJhbmRvbSg5KSsxKS8xMFxuICAgICAgICB3aWR0aDogMzJcbiAgICAgICAgaGVpZ2h0OiAzMlxuICAgICAgICBwYXR0ZXJuTnVtOiByYW5kb20oMilcbiAgICAgICAgcGF0dGVybkxpc3Q6IFtcbiAgICAgICAgICBbMTAwLCBbMTAsIDExLCAxMCwgMTJdXVxuICAgICAgICAgIFsxMDAsIFs1LCA2LCA1LCA3XV1cbiAgICAgICAgICBbMTAwLCBbMCwgMSwgMCwgMl1dXG4gICAgICAgIF1cbiAgICAgIGlmIChraW5kID09IDApXG4gICAgICAgIGFwcC5hZGRTcHJpdGUoc3ByaXRlLCAwKVxuICAgICAgZWxzZVxuICAgICAgICBhcHAuYWRkU3ByaXRlKHNwcml0ZSlcbiAgICAgIHNwcml0ZXMucHVzaChzcHJpdGUpXG5cbiAgICBmb3IgaSBpbiBbMC4uLjEwMF1cbiAgICAgIGtpbmQgPSByYW5kb20oMSlcbiAgICAgIHNjYWxlID0gKHJhbmRvbSgxMykgKyAzKSAvIDNcbiAgICAgIHNwcml0ZSA9IGFwcC5uZXdTcHJpdGVcbiAgICAgICAgeDogcmFuZG9tKHdpZHRoKjIpIC0gd2lkdGhcbiAgICAgICAgeTogcmFuZG9tKDUwKSs3MFxuICAgICAgICB6OiByYW5kb20od2lkdGgqOCkgLSB3aWR0aCo0XG4gICAgICAgIHhzOiAocmFuZG9tKDgpIC0gNCkgKiAyXG4gICAgICAgIHpzOiAocmFuZG9tKDgpIC0gNCkgKiAyXG4gICAgICAgIGdyYXZpdHk6IDNcbiAgICAgICAgb3Jnc2NhbGU6ICgoa2luZCAqIDEyMCkgKyAxMCkgKiAxXG4gICAgICAgIHhzY2FsZTogc2NhbGVcbiAgICAgICAgeXNjYWxlOiBzY2FsZVxuICAgICAgICB6c2NhbGU6IHNjYWxlXG4gICAgICAgIHhyb3RhdGU6IDBcbiAgICAgICAgeXJvdGF0ZTogMFxuICAgICAgICB6cm90YXRlOiAwXG4gICAgICAgIG9iamVjdDogaWYgKGtpbmQgPT0gMCkgdGhlbiBhc3NldHNbJ25lZ2ltaWt1J10gZWxzZSBhc3NldHNbJ2Ryb2lkJ11cbiAgICAgIGFwcC5hZGRTcHJpdGUoc3ByaXRlKVxuICAgICAgc3ByaXRlcy5wdXNoKHNwcml0ZSlcblxuICAgIGNhbWVyYV9yYWRpdXMgPSAwXG4gICAgY2FtZXJhX3ggPSA1MDAwXG4gICAgY2FtZXJhX3kgPSA1MDAwXG4gICAgY2FtZXJhX3ogPSA1MDAwXG4gICAgYXBwLkNBTUVSQTNELnBvc2l0aW9uLnNldChjYW1lcmFfeCwgY2FtZXJhX3ksIGNhbWVyYV96KVxuICAgIGFwcC5lbnRlcmZyYW1lIC0+XG4gICAgICAjY2FtZXJhX3ggPSBNYXRoLmNvcyhjYW1lcmFfcmFkaXVzICogUkFEKSAqIDUwMDBcbiAgICAgICNjYW1lcmFfeSA9IDMwMDBcbiAgICAgICNjYW1lcmFfeiA9IE1hdGguc2luKGNhbWVyYV9yYWRpdXMgKiBSQUQpICogNTAwMFxuICAgICAgI2NhbWVyYV9yYWRpdXMgPSArK2NhbWVyYV9yYWRpdXMgJSAzNjBcbiAgICAgIGFwcC5DQU1FUkEzRC5sb29rQXQoY3ViZS54LCBjdWJlLnksIGN1YmUueilcbiAgICAgIGZvciBzcHJpdGUgaW4gc3ByaXRlc1xuICAgICAgICBpZiAoc3ByaXRlLm9iamVjdC50eXBlID09ICdpbWFnZScpXG4gICAgICAgICAgc3ByaXRlLnJvdGF0ZS0tXG4gICAgICAgICAgaWYgKHNwcml0ZS54IDwgMClcbiAgICAgICAgICAgIHNwcml0ZS54ID0gd2lkdGhcbiAgICAgICAgICBpZiAoc3ByaXRlLnggPiB3aWR0aClcbiAgICAgICAgICAgIHNwcml0ZS54ID0gMFxuICAgICAgICAgIGlmIChzcHJpdGUueSA+IGhlaWdodC0oc3ByaXRlLmhlaWdodC8yKSlcbiAgICAgICAgICAgIHNwcml0ZS55ID0gaGVpZ2h0LShzcHJpdGUuaGVpZ2h0LzIpXG4gICAgICAgICAgICBzcHJpdGUueXMgKj0gLTFcbiAgICAgICAgZWxzZVxuICAgICAgICAgIHNwcml0ZS54cm90YXRlKytcbiAgICAgICAgICBzcHJpdGUueXJvdGF0ZSsrXG4gICAgICAgICAgc3ByaXRlLnpyb3RhdGUrK1xuICAgICAgICAgIGlmIChzcHJpdGUueCA8IC13aWR0aCozKVxuICAgICAgICAgICAgc3ByaXRlLnggPSB3aWR0aCozXG4gICAgICAgICAgaWYgKHNwcml0ZS54ID4gd2lkdGgqMylcbiAgICAgICAgICAgIHNwcml0ZS54ID0gLXdpZHRoKjNcbiAgICAgICAgICBpZiAoc3ByaXRlLnogPCAtd2lkdGgqNilcbiAgICAgICAgICAgIHNwcml0ZS56ID0gd2lkdGgqNlxuICAgICAgICAgIGlmIChzcHJpdGUueiA+IHdpZHRoKjYpXG4gICAgICAgICAgICBzcHJpdGUueiA9IC13aWR0aCo2XG4gICAgICAgICAgaWYgKHNwcml0ZS55IDwgMClcbiAgICAgICAgICAgIHNwcml0ZS55ID0gMFxuICAgICAgICAgICAgc3ByaXRlLnlzID0gKHJhbmRvbSg2NCkrMzIpXG5cbiAgICAgIGlmIChjdWJlLnggPCAtd2lkdGgqMylcbiAgICAgICAgY3ViZS54ID0gLXdpZHRoKjNcbiAgICAgICAgY3ViZS54cyAqPSAtMVxuICAgICAgaWYgKGN1YmUueCA+IHdpZHRoKjMpXG4gICAgICAgIGN1YmUueCA9IHdpZHRoKjNcbiAgICAgICAgY3ViZS54cyAqPSAtMVxuICAgICAgaWYgKGN1YmUueiA8IC13aWR0aCozKVxuICAgICAgICBjdWJlLnogPSAtd2lkdGgqM1xuICAgICAgICBjdWJlLnpzICo9IC0xXG4gICAgICBpZiAoY3ViZS56ID4gd2lkdGgqMylcbiAgICAgICAgY3ViZS56ID0gd2lkdGgqM1xuICAgICAgICBjdWJlLnpzICo9IC0xXG4gICAgICBpZiAoY3ViZS55IDwgMClcbiAgICAgICAgY3ViZS55ID0gMFxuICAgICAgICBjdWJlLnlzID0gKHJhbmRvbSgyNTYpKzMyKVxuXG4iXX0=
//# sourceURL=/home/kow/work_area/usr/local/lib/PixelirJS/DEMO/main.coffee
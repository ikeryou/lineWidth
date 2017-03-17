Param    = require('../core/Param')
Conf     = require('../core/Conf')
Func     = require('../core/Func')
Util     = require('../libs/Util')
Delay    = require('../libs/Delay')


class Line extends THREE.Object3D

  constructor: ->

    super()

    @_line = []
    @_grav = []

    @_cnt = Util.random(0, 1000)



  # -----------------------------------
  # 初期化
  # -----------------------------------
  init: =>

    colors = [0xeeba21, 0xf1d3d0, 0xe74b29, 0x316694]
    i = 0
    num = colors.length
    while i < num

      mat = new THREE.MeshBasicMaterial({
        color : colors[i]
      })

      mesh = new THREE.Mesh(@_makeGeo(0, 0), mat)
      @add(mesh)
      mesh.position.z = i

      @_line.push({
        mesh:mesh
      })

      i++


    i = 0
    gravNum = 10
    while i < gravNum
      @_grav.push(new THREE.Vector3())
      i++



  # -----------------------------------
  # TubeBufferGeometryの作成、取得
  # -----------------------------------
  _makeGeo: (grav, offset) =>

    arr = []

    i = 0
    fineness = 10
    while i <= fineness

      radian1 = Util.radian(offset * 0.5 + i * 50)
      radian2 = Util.radian(offset * 0.5)

      offsetY = Math.sin(radian2) * Math.sin(radian1) * 0.05

      v = new THREE.Vector3(
        -0.5 + (1/fineness) * i,
        offsetY,
        0
      )

      for val,l in grav
        d = v.distanceTo(val)
        power = Math.pow((1 - d) * 0.8, 10) * 100
        v.y += power * val.y * 0.3

      arr.push(v)

      i++

    # なめらかなパス作成
    path = new THREE.CatmullRomCurve3(arr)

    # 線の太さ
    lineWidth = Param.line.lineWidth.value

    # 線の滑らかさ
    # でかいと重いけど滑らかになる
    lineFineness = 300

    return new THREE.TubeBufferGeometry(path, lineFineness, lineWidth, 3, false)



  # -----------------------------------
  # 更新
  # -----------------------------------
  update: =>

    @_cnt += Param.line.speed.value

    for val,i in @_grav
      radian = Util.radian(i * (360/@_grav.length) + @_cnt) * 0.5
      val.x = Math.cos(radian * 2) * 0.5
      val.y = Math.sin(radian * 0.9) * 0.25

    for val,i in @_line

      # 頂点作成
      newGeo = @_makeGeo(@_grav, i * (90/@_line.length) + @_cnt)
      newPos = newGeo.attributes.position.array

      # 頂点いれかえ
      p = val.mesh.geometry.attributes.position
      p.array = newPos
      p.needsUpdate = true

      # 破棄
      newGeo.dispose()



  # -----------------------------------
  # 画面サイズ
  # -----------------------------------
  size: (w, h) =>

    scale = Math.max(w, h) * 1.1
    @scale.set(scale, scale, 1)





module.exports = Line

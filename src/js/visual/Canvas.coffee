MyDisplay = require('../core/MyDisplay')
Param     = require('../core/Param')
Func      = require('../core/Func')
Util      = require('../libs/Util')
Delay     = require('../libs/Delay')
Point     = require('../libs/obj/Point')
Line       = require('./Line')


class Canvas extends MyDisplay


  constructor: ->

    super({
      update:true
      resize:true
      el:$('#main')
    })

    @camera
    @renderer
    @mainScene

    @_line



  # -----------------------------------------------
  # 初期化
  # -----------------------------------------------
  init: =>

    super()

    @_makeCamera()
    @_makeRenderer()
    @_makeMainScene()

    @_line = new Line()
    @_line.init()
    @mainScene.add(@_line)

    @_resize()



  # -----------------------------------------------
  # 更新
  # -----------------------------------------------
  _update: =>

    super()

    @_line.update()

    @renderer.render(@mainScene, @camera)



  # -----------------------------------------------
  # リサイズ
  # -----------------------------------------------
  _resize: =>

    size = Func.stageSize()
    w = size.width
    h = size.height

    @_line.size(w, h)

    # ピクセル等倍にする
    @camera.aspect = w / h
    @camera.updateProjectionMatrix()
    @camera.position.z = h / Math.tan(@camera.fov * Math.PI / 360) / 2

    @renderer.setPixelRatio(window.devicePixelRatio || 1)
    @renderer.setSize(w, h, true)



  # -----------------------------------------------
  # カメラ作成
  # -----------------------------------------------
  _makeCamera: =>

    @camera = new THREE.PerspectiveCamera(45, 1, 1, 20000)



  # -----------------------------------------------
  # レンダラー作成
  # -----------------------------------------------
  _makeRenderer: =>

    @renderer = new THREE.WebGLRenderer({
      canvas             : document.getElementById(@el().attr('id'))
      alpha              : false
      antialias          : false
      stencil            : false
      depth              : true
      premultipliedAlpha : false
    })
    @renderer.autoClear = true
    @renderer.setClearColor(0xffffff)



  # -----------------------------------------------
  # メインシーン作成
  # -----------------------------------------------
  _makeMainScene: =>

    @mainScene = new THREE.Scene()









module.exports = Canvas

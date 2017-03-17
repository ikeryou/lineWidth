dat    = require('dat-gui')
Conf   = require('./Conf')
Update = require('../libs/Update')


# ---------------------------------------------------
# パラメータ
# ---------------------------------------------------
class Param

  constructor: ->

    @_gui

    @line = {
      lineWidth:{value:0.02, min:0.001, max:0.05}
      speed:{value:1.2, min:0.001, max:3.9}
    }

    @_init()



  # -----------------------------------------------
  # 初期化
  # -----------------------------------------------
  _init: =>

    Update.add(@_update)

    if !Conf.FLG.PARAM
      return

    @_gui = new dat.GUI()
    @_addGui(@line, 'param')

    $('.dg').css('zIndex', 99999999)



  # -----------------------------------------------
  #
  # -----------------------------------------------
  _addGui: (obj, folderName) =>

    folder = @_gui.addFolder(folderName)

    for key,val of obj
      if key.indexOf('Color') > 0
        folder.addColor(val, 'value').name(key)
      else
        if val.list?
          folder.add(val, 'value', val.list).name(key)
        else
          folder.add(val, 'value', val.min, val.max).name(key)



  # -----------------------------------------------
  #
  # -----------------------------------------------
  _listen: (param, name) =>

    if !name? then name = param
    @_gui.add(@, param).name(name).listen()



  # -----------------------------------
  # 更新
  # -----------------------------------
  _update: =>








module.exports = new Param()

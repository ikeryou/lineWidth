Entry    = require('../core/Entry')
Profiler = require('../core/Profiler')
Canvas   = require('../visual/Canvas')


# エントリーポイント
class Top extends Entry

  constructor: ->

    super()



  init: =>

    super()

    canvas = new Canvas()
    canvas.init()





module.exports = Top


main = new Top()
main.init()

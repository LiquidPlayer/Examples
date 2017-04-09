var BigNumber = require('bignumber.js')

setInterval(function() {}, 1000)

LiquidCore.on( 'ping', function() {
    var x = new BigNumber(1011, 2)          // "11"
    var y = new BigNumber('zz.9', 36)       // "1295.25"
    var z = x.plus(y)                       // "1306.25"
    LiquidCore.emit( 'pong', { message: '' + x + ' + ' + y + ' = ' + z } )
    process.exit(0)
})

LiquidCore.emit( 'ready' )


if (typeof LiquidCore !== 'undefined') {
    LiquidCore.attach(
        'org.liquidplayer.surface.console.ConsoleSurface',
        (error) => {
            if (!error) {
                require('./cmd.js')
            }
        }
    )
} else {
    require('./cmd.js')
}

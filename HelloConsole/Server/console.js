// This will keep the process alive until an explicit process.exit() call
setInterval(function(){},1000)

// This will attempt to attach to a ConsoleSurface
LiquidCore.attach('org.liquidplayer.surface.console.ConsoleSurface', (error) => {
    console.log("Hello, Console!")
    if (error) {
        console.error(error)
    }
})

window.onload = () ->
    director = new CAAT.Director().initialize( 300, 300)
    document.getElementById('animation-place').appendChild(director.canvas)
    scene = director.createScene()
    circle = new CAAT.ShapeActor()
        .setLocation(20,20)
        .setSize(60,60)
        .setFillStyle('#ff0000')
        .setStrokeStyle('#000000')
        .enableDrag()
        .setFrameTime(0, 2000)
        .addListener(
            actorLifeCycleEvent : (actor, event_type, time) ->
                if event_type is 'expired'
                    actor.setFrameTime(time + 1000, 2000)
        )
    scene.addChild(circle)
    director.loop(1)

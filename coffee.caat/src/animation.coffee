window.onload = () ->

    class GameBoard
        @width = 800
        @height = 400
        constructor : () ->

    class SpaceShip
        constructor : (@name) ->
            @_actor = new CAAT.Actor()
            .setLocation(20, 20)
            .setSize(30, 30)
            .setFillStyle('#ff5588')
            .setStrokeStyle('#ffffff')
        getActor : () ->
            width = GameBoard.width
            height = Math.random() * (GameBoard.height - 30)
            @_actor.setLocation(800, height)

            endPoint = Math.random() * (GameBoard.height - 30)
            movePath = new CAAT.LinearPath().
                setInitialPosition(800, height).
                setFinalPosition(0 - 30, endPoint)


            behavior = new CAAT.PathBehavior()
                .setPath( movePath )
                .setFrameTime(director.time ,5000)

            @_actor.addBehavior( behavior )

            @_actor

    director = new CAAT.Director().initialize(GameBoard.width, GameBoard.height)
    console.log director
    document.getElementById('animation-place').appendChild(director.canvas)
    scene = director.createScene()
    user = new CAAT.Actor()
        .setBounds(120, 20, 80, 80)
        .setFillStyle('#ff5500')
        .setStrokeStyle('#000000')
    user.name = 'UserActor'
        

    bg = new CAAT.ActorContainer().
        setBounds(0,0,director.width,director.height).
        setFillStyle('#000')
    scene.addChild(bg)

    window.setInterval(() ->
        ship = new SpaceShip('ship1')
        scene.addChild(ship.getActor())
        ship = new SpaceShip('ship2')
        scene.addChild(ship.getActor())
        ship = new SpaceShip('ship3')
        scene.addChild(ship.getActor())
    1500)

    bg.addChild(user)
    director.loop(1)

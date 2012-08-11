window.onload = () ->

    class GameBoard
        @width = 800
        @height = 400
        constructor : () ->

    class Player extends CAAT.Actor

        width  : 40
        height : 40
        startX : 0
        startY : 0

        moveVector : [0,0,0,0]

        constructor : (@_scene) ->
            super
            @.setLocation(@startX, @startY)
            .setSize(@width, @height)
            .setFillStyle('#ff5588')
            @_scene.addChild(@)
            @.enableKeyboardControls()

        enableKeyboardControls : () ->
            self = @
            CAAT.registerKeyListener( (keyEvent) ->
                if keyEvent.getKeyCode() == CAAT.Keys.UP
                    self.moveVector[2] = if keyEvent.getAction() == 'down' then 1 else 0
                if keyEvent.getKeyCode() == CAAT.Keys.DOWN
                    self.moveVector[3] = if keyEvent.getAction() == 'down' then 1 else 0
                if keyEvent.getKeyCode() == CAAT.Keys.LEFT
                    self.moveVector[0] = if keyEvent.getAction() == 'down' then 1 else 0
                if keyEvent.getKeyCode() == CAAT.Keys.RIGHT
                    self.moveVector[1] = if keyEvent.getAction() == 'down' then 1 else 0
            )
            pixelsPerSecond = 8
            @_scene.createTimer(@_scene.time, Number.MAX_VALUE, null, (sceneTime, timerTime, taskObject) ->
                self.x +=  pixelsPerSecond * (self.moveVector[1]-self.moveVector[0])
                self.y +=  pixelsPerSecond * (self.moveVector[3]-self.moveVector[2])
                if self.x + self.width > GameBoard.width then self.x = GameBoard.width - self.width
                if self.x < 0 then self.x = 0
                if self.y + self.height > GameBoard.height then self.y = GameBoard.height - self.height
                if self.y < 0 then self.y = 0
            , null)



    class Application extends CAAT.Director
        constructor : () ->
            super
            @.initialize(GameBoard.width, GameBoard.height)
            console.log @
            document.getElementById('animation-place').appendChild(@canvas)

        getScene : () ->
            @scene = director.createScene()
           
        setActorContainer : () ->
            container = new CAAT.ActorContainer().
                setBounds(0,0, @width, @height).
                setFillStyle('#000')
            @scene.addChild(container)
            container

        start : () ->
            @.loop(160)

    director = new Application
    director.getScene()
    director.setActorContainer()
    director.start()

    player = new Player(director.scene)
    













    class SpaceShip
        constructor : (@name) ->
            @_actor = new CAAT.Actor()
            .setLocation(20, 20)
            .setSize(30, 30)
            .setFillStyle('#ff5588')
            .setStrokeStyle('#ffffff')
            .setDiscardable(true)
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
    keeper = () ->
        director = new CAAT.Director().initialize(GameBoard.width, GameBoard.height)
        console.log director
        document.getElementById('animation-place').appendChild(director.canvas)
        scene = director.createScene()
        user = new CAAT.Actor()
            .setBounds(120, 20, 80, 80)
            .setFillStyle('#ff5500')
            .setStrokeStyle('#000000')
        user.name = 'UserActor'
            


        window.setInterval(() ->
            #ship = new SpaceShip('ship1')
            #scene.addChild(ship.getActor())
            #ship = new SpaceShip('ship2')
            #scene.addChild(ship.getActor())
            #ship = new SpaceShip('ship3')
            #scene.addChild(ship.getActor())
        1500)


window.onload = () ->
    class GameBoard
        @width = 800
        @height = 400
        constructor : () ->

    class Player extends CAAT.Actor
        startX     : 0
        startY     : 0
        speed      : 8 # pixels per timer tick
        moveVector : [0,0,0,0]

        constructor : (@_scene) ->
            super
            playerImage = new CAAT.SpriteImage().initialize(director.getImage('player'), 1, 1)
            @.setLocation(@startX, @startY)
            .setFillStyle('#ff5588')
            .setBackgroundImage(playerImage.getRef(), true )
            .setScale(0.5, 0.5)
            .enableKeyboardControlsForObject()
            @_scene.addChild(@)

        enableKeyboardControlsForObject : () ->
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
            @_scene.createTimer(@_scene.time, Number.MAX_VALUE, null, (sceneTime, timerTime, taskObject) ->
                self.x +=  self.speed * (self.moveVector[1]-self.moveVector[0])
                self.y +=  self.speed * (self.moveVector[3]-self.moveVector[2])
                if self.x + self.width > GameBoard.width then self.x = GameBoard.width - self.width
                if self.x < 0 then self.x = 0
                if self.y + self.height > GameBoard.height then self.y = GameBoard.height - self.height
                if self.y < 0 then self.y = 0
            , null)

    class Alien extends CAAT.Actor
        speed      : 8 # pixels per timer tick
        moveVector : [0,0,0,0]

        constructor : (@_scene) ->
            super
            @.setLocation(100, 100)
            alienImage = new CAAT.SpriteImage().initialize(director.getImage('alien'), 1, 1)
            @.setBackgroundImage(alienImage.getRef(), true )
            .setLocation(GameBoard.width + @width, 200)
            @_scene.addChild(@)
            @.attack()

        attack : () ->
            startPoint = Math.random() * (GameBoard.height - @height)
            endPoint = Math.random() * (GameBoard.height - @height)
            movePath = new CAAT.LinearPath().
                setInitialPosition(GameBoard.width, startPoint)
                .setFinalPosition(-30, endPoint)
            behavior = new CAAT.PathBehavior()
                .setPath( movePath )
                .setFrameTime(director.time ,5000)
            @.addBehavior( behavior )


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

        preloadApplication : () ->
            self = @
            new CAAT.ImagePreloader().loadImages( [
                { id : 'player', url : 'gfx/player.png'},
                { id : 'alien', url  : 'gfx/alien.png'},
            ], ( counter, images ) ->
                self.setImagesCache(images)
                self.start()
            )

        start : () ->
            @getScene()
            @setActorContainer()
            player = new Player(@scene)
            ticker = 0
            @scene.createTimer(@scene.time, Number.MAX_VALUE, null, (sceneTime, timerTime, taskObject) ->
                ticker += 1
                if (ticker % 100) == 0
                    alien = new Alien(@scene)
            , null)



            @.loop(10)

    director = new Application
    director.preloadApplication()

    













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


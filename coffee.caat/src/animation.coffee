window.onload = () ->
    class GameBoard
        @width = 800
        @height = 400
        constructor : () ->

    class Player extends CAAT.Actor
        score      : 0
        @hp         : 100
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
            @.enableCollisions()
            @_scene.addChild(@)

        checkCollisionsWith : (alien) ->
            if alien.x < (@.x + @.width) and alien.x > @.x and alien.y < (@.y + @.height) and alien.y > @.y
                alien.destroy()
                Player.hp = Player.hp - 1

        enableCollisions : () ->
            self = @
            @_scene.createTimer(@_scene.time, Number.MAX_VALUE, null, (sceneTime, timerTime, taskObject) ->
                for alien in Application.aliens
                    self.checkCollisionsWith alien
            , null)

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
        lifeTime   : 5000

        constructor : (@_scene) ->
            super
            @.setLocation(100, 100)
            .setDiscardable(true)
            .setFrameTime(@_scene.time, @lifeTime)
            alienImage = new CAAT.SpriteImage().initialize(director.getImage('alien'), 1, 1)
            @.setBackgroundImage(alienImage.getRef(), true )
            .setLocation(GameBoard.width + @width, 200)
            @_scene.addChild(@)
            @.attack()

        destroy : () ->
            @.setFrameTime(0, 0)

        attack : () ->
            startPoint = Math.random() * (GameBoard.height - @height)
            endPoint = Math.random() * (GameBoard.height - @height)
            movePath = new CAAT.LinearPath().
                setInitialPosition(GameBoard.width, startPoint)
                .setFinalPosition(-30, endPoint)
            behavior = new CAAT.PathBehavior()
                .setPath( movePath )
                .setFrameTime(director.time, @lifeTime)
            @.addBehavior( behavior )

    class Application extends CAAT.Director
        playerHpText    : null
        playerScoreText : null
        @aliens          : []

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

        insertAliens : () ->
            ticker = 0
            @scene.createTimer(@scene.time, Number.MAX_VALUE, null, (sceneTime, timerTime, taskObject) ->
                randomTime = Math.round(Math.random() * 500)
                randomCount = Math.round(Math.random() * 2)
                ticker += 1
                if (ticker % randomTime) == 0
                    aliens = for i in [1..randomCount]
                        new Alien(@scene)
                    Application.aliens = Application.aliens.concat aliens
            , null)

        start : () ->
            @getScene()
            console.log @scene
            @setActorContainer()
            player = new Player(@scene)
            @.insertAliens()
            @scene.addChild(@.getPlayerHpText())
            @scene.addChild(@.getPlayerScoreText())
            @.createTextsTimer()
            @.loop(10)

        createTextsTimer : () ->
            self = @
            @scene.createTimer(@scene.time, Number.MAX_VALUE, null, (sceneTime, timerTime, taskObject) ->
                console.log Player.hp
                self.playerHpText.setText("HP: #{Player.hp}")
                self.playerScoreText.setText("SCORE: #{Player.score}")
            , null)

        getPlayerHpText : () ->
            if @playerHpText?
                @playerHpText
            else
                @playerHpText = new CAAT.TextActor()
                .setFont("20px Lucida sans")
                .setLocation(20, 20)
                .setOutline(false)
                .enableEvents(false)
                .setText('HP: 100')


        getPlayerScoreText : () ->
            if @playerScoreText?
                @playerScoreText
            else
                @playerScoreText = new CAAT.TextActor()
                .setFont("20px Lucida sans")
                .setLocation(120, 20)
                .setOutline(false)
                .enableEvents(false)
                .setText('SCORE: 100')

    director = new Application
    director.preloadApplication()

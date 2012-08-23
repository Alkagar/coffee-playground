window.onload = () ->
    
    class GameBoard
        @width = 900
        @height = 600
        constructor : () ->

    class Player extends CAAT.Actor
        @bullets   : []
        @score      : 0
        @hp        : 100
        startX     : 0
        startY     : 0
        speed      : 8 # pixels per timer tick
        moveVector : [0,0,0,0]
        bulletsShot : 0

        constructor : (@_scene) ->
            super
            playerImage = new CAAT.SpriteImage().initialize(director.getImage('player'), 1, 1)
            @.setLocation(@startX, @startY)
            .setFillStyle('#ff5588')
            .setBackgroundImage(playerImage.getRef(), true )
            .enableKeyboardControlsForObject()
            @.enableCollisions()
            @_scene.addChild(@)

        checkCollisionsWith : (alien) ->
            if alien.x < (@.x + @.width) and alien.x > @.x and alien.y < (@.y + @.height) and alien.y > @.y
                alien.destroy()
                Player.hp = Player.hp - alien.attackPower
                if Player.hp <= 0
                    alert('Game Over')
                    location.reload()

        enableCollisions : () ->
            self = @
            @_scene.createTimer(@_scene.time, Number.MAX_VALUE, null, (sceneTime, timerTime, taskObject) ->
                for alien in Application.aliens
                    self.checkCollisionsWith alien
                    for bullet in Player.bullets
                        alien.checkCollisionsWith bullet
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
                if keyEvent.getKeyCode() == CAAT.Keys.a
                    self.bulletsShot = 1
            )
            ms = 0
            @_scene.createTimer(@_scene.time, 1, (sceneTime, timerTime, taskObject) ->

                ms+=1
                taskObject.reset(sceneTime)

                self.x +=  self.speed * (self.moveVector[1]-self.moveVector[0])
                self.y +=  self.speed * (self.moveVector[3]-self.moveVector[2])
                if self.x + self.width > GameBoard.width then self.x = GameBoard.width - self.width
                if self.x < 0 then self.x = 0
                if self.y + self.height > GameBoard.height then self.y = GameBoard.height - self.height
                if self.y < 0 then self.y = 0
                if ms % 20 == 0 and self.bulletsShot > 0
                    self.fireGun()
                    self.bulletsShot = 0
            , null, null)

        fireGun : () ->
            bullet = new NormalBullet(@_scene, @)
            bullets = [bullet]
            Player.bullets = Player.bullets.concat bullets


    class NormalBullet extends CAAT.ShapeActor
        constructor : (@_scene, player) ->
            super
            @.setShape( CAAT.ShapeActor.prototype.SHAPE_CIRCLE )
            .setSize(5, 5)
            .setFillStyle( 'yellow' )

            startPointX = player.x + player.width / 2
            startPointY = player.y + player.height / 2
            
            movePath = new CAAT.LinearPath()
                .setInitialPosition(startPointX, startPointY)
                .setFinalPosition(startPointX + GameBoard.width, startPointY)
            behavior = new CAAT.PathBehavior()
                .setPath( movePath )
                .setFrameTime(@_scene.time, 2000)
            @.addBehavior( behavior )
            @_scene.addChild(@)

        destroy : () ->
            @.setFrameTime(0, 0)
            .setLocation(-100, -100)


    class Alien extends CAAT.Actor
        speedMax    : 2
        speedMin    : 1
        attackPower : 5
        moveVector  : [0,0,0,0]
        lifeTime    : 5000
        value       : 1

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

        checkCollisionsWith : (bullet) ->
            if bullet.x < (@.x + @.width) and bullet.x > @.x and bullet.y < (@.y + @.height) and bullet.y > @.y
                @.destroy()
                bullet.destroy()
                Player.score = Player.score + @value

        destroy : () ->
            @.setFrameTime(0, 0)
            .setLocation(-100, -100)

        attack : () ->
            startPoint = Math.random() * (GameBoard.height - @height)
            endPoint = Math.random() * (GameBoard.height - @height)
            movePath = new CAAT.LinearPath().
                setInitialPosition(GameBoard.width, startPoint)
                .setFinalPosition(-50, endPoint)
            speed = Math.random() * @speedMax + @speedMin
            behavior = new CAAT.PathBehavior()
                .setPath( movePath )
                .setFrameTime(@_scene.time, @lifeTime / speed)
            @.addBehavior( behavior )

    class Application extends CAAT.Director
        playerHpText    : null
        playerScoreText : null
        @aliens          : []

        constructor : () ->
            super
            @.initialize(GameBoard.width, GameBoard.height)
            document.getElementById('animation-place').appendChild(@canvas)

        getScene : () ->
            @scene = director.createScene()
            
        setActorContainer : () ->
            @container = new CAAT.ActorContainer().
                setBounds(0,0, @width, @height).
                setFillStyle('#000')
            @scene.addChild(@container)
            @container

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
            self = @
            CAAT.loop(60)
            @getScene()
            @setActorContainer()
            startG = new CAAT.TextActor()
            @scene.addChild(startG)
            startG.setFont("20px Quantico")
                .setLocation(GameBoard.width / 2, GameBoard.height / 2)
                .setOutline(false)
                .enableEvents(true)
                .setText('Start Game')
                .mouseClick = (mouseEvent) ->
                    self.startGame()


        startGame : () ->
            @getScene()
            ind = @.getSceneIndex(@scene)
            @setActorContainer()
            @.easeIn(ind)
            player = new Player(@scene)
            @.insertAliens()
            @.setPlayerHpText()
            @.setPlayerScoreText()
            @scene.addChild(@playerHpText)
            @scene.addChild(@playerScoreText)
            @.createTextsTimer(@playerHpText, @playerScoreText)

        createTextsTimer : (hp, score) ->
            self = @
            @scene.createTimer(@scene.time, Number.MAX_VALUE, null, (sceneTime, timerTime, taskObject) ->
                hp.setText("HP: #{Player.hp}")
                score.setText("SCORE: #{Player.score}")
            , null)

        setPlayerHpText : () ->
            @playerHpText = new CAAT.TextActor()
                .setFont("20px Quantico")
                .setLocation(20, 20)
                .setOutline(false)
                .enableEvents(true)
                .setText('HP: 100')

        setPlayerScoreText : () ->
            @playerScoreText = new CAAT.TextActor()
                .setFont("20px Quantico")
                .setLocation(120, 20)
                .setOutline(false)
                .enableEvents(false)
                .setText('SCORE: 0')

    director = new Application
    director.preloadApplication()

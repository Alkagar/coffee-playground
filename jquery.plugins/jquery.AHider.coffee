#  Project: AHider - jQuery hiding plugin
#  Description:
#  Author: Jakub Alkagar Mrowiec
#

(($, window) ->
    # Create the defaults once
    pluginName = 'AHider'
    document = window.document
    defaults =
        showText                : '[ show ]'
        hideText                : '[ hide ]'
        toggleButtonClass       : 'a-hider-button'
        toggleBoxClass          : 'a-hider-box'
        defaultState            : 'hidden' # visible|hidden
        hiddenClass             : 'a-hider-hidden'
        visibleClass            : 'a-hider-visible'

        visibleWords            : 15
        animationTime           : 2000

    # The actual plugin constructor
    class Plugin
        constructor: (@element, options = {}) ->
            # Place your constructor here
            @options = $.extend {}, defaults, options
            @_defaults = defaults
            @_name = pluginName
            @_visibleText = ''
            @_hiddenText = ''
            @_originalText = ''
            @init()

        _prepareText: (text) ->
            options = @options
            self = @
            @_visibleText = text.trim().split(' ').slice(0, options.visibleWords).join(' ')
            @_hiddenText = text.trim().split(' ').slice(options.visibleWords).join(' ')
            @_originalText = text
        
        init: ->
            $(@).each ->
                options = @options
                self = @

                container = @element
                toggleButton = container.find('.' + options.toggleButtonClass)
                toggleButton.css 'cursor', 'pointer'

                toggleBox = container.find '.' + options.toggleBoxClass
                @._prepareText(toggleBox.text())
                visibleText = $('<span/>').text(@_visibleText)
                hiddenText = $('<span/>').text(@_hiddenText)
                originalText = $('<div/>').text(@_originalText)

                toggleBox.text('').append(originalText)
                textHeight = container.outerHeight(true) + 10
                alert(textHeight)
                originalText.hide()
                    
                toggleBox.append(visibleText).append(' ').append(hiddenText).css('overflow', 'hidden')

                if options.defaultState is 'hidden'
                    toggleButton.addClass(options.hiddenClass).text(options.showText)
                    hiddenText.hide()
                else
                    toggleButton.addClass(options.visibleClass).text(options.hideText)
                    hiddenText.show()

                toggleButton.on 'click', () ->
                    toggleBox = $(@).siblings('.' + options.toggleBoxClass)
                    $(@).toggleClass(options.hiddenClass).toggleClass(options.visibleClass)
                    #hiddenText.slideToggle 1500, 'linear'
                    if $(@).is('.' + options.hiddenClass)
                        $(@).text options.showText
                        toggleBox.animate {height:visibleText.height()}, options.animationTime, () ->
                            hiddenText.hide()
                    else
                        $(@).text options.hideText
                        hiddenText.show()
                        toggleBox.css('height', visibleText.height()).animate({height:textHeight}, options.animationTime)



# Place initialization logic here

        # A really lightweight plugin wrapper around the constructor,
        # preventing against multiple instantiations
    $.fn[pluginName] = (options = {}) ->
        @each ->
            if !$.data(this, "plugin_#{pluginName}")
                $.data($(@), "plugin_#{pluginName}", new Plugin($(@), options))
)(jQuery, window)

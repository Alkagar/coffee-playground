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

    # The actual plugin constructor
    class Plugin
        constructor: (@element, options = {}) ->
            # Place your constructor here
            @options = $.extend {}, defaults, options
            @_defaults = defaults
            @_name = pluginName
            @init()
        
        init: ->
            $(@).each ->
                options = @options
                self = @

                container = @element
                toggleButton = container.find('.' + options.toggleButtonClass)
                toggleButton.css 'cursor', 'pointer'

                toggleBox = container.find '.' + options.toggleBoxClass

                if options.defaultState is 'hidden'
                    toggleButton.addClass(options.hiddenClass).text(options.showText)
                    toggleBox.hide()
                else
                    toggleButton.addClass(options.visibleClass).text(options.hideText)
                    toggleBox.show()


                toggleButton.on 'click', () ->
                    toggleBox = $(@).siblings('.' + options.toggleBoxClass)
                    $(@).toggleClass(options.hiddenClass).toggleClass(options.visibleClass)
                    toggleBox.toggle 'slow'
                    if $(@).is('.' + options.hiddenClass)
                        $(@).text options.showText
                    else
                        $(@).text options.hideText


            # Place initialization logic here

        # A really lightweight plugin wrapper around the constructor,
        # preventing against multiple instantiations
    $.fn[pluginName] = (options = {}) ->
        @each ->
            if !$.data(this, "plugin_#{pluginName}")
                $.data($(@), "plugin_#{pluginName}", new Plugin($(@), options))
)(jQuery, window)

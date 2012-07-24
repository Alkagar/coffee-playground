#  Project: 
#  Description:
#  Author: 
#  License:
(($, window) ->
    # Create the defaults once
    pluginName = 'yourPluginName'
    document = window.document
    defaults =
        defaultValue = 'value'

    # The actual plugin constructor
    class Plugin
        constructor: (@element, options = {}) ->
            # Place your constructor here
            @options = $.extend {}, defaults, options
            @_defaults = defaults
            @_name = pluginName
            @init()

        init: ->
            # Place initialization logic here

        # A really lightweight plugin wrapper around the constructor,
        # preventing against multiple instantiations
        $.fn[pluginName] = (options = {}) ->
            @each ->
                if !$.data(this, "plugin_#{pluginName}")
                    $.data(@, "plugin_#{pluginName}", new Plugin(@, options))
)(jQuery, window)

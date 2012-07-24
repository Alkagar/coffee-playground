


(function( $ ){
    $.fn.hider = function(options) {
        return this.each(function() {
            var mainContainer = $(this);
            var toggleButton = mainContainer.find('.' + settings.toggleButtonClass);
            var toggleBox = mainContainer.find('.' + settings.toggleBoxClass);
            if(settings.defaultState == 'hidden') {
                toggleButton.addClass('hider-hidden').text(settings.rollUpText);
                toggleBox.hide();
            } else {
                toggleButton.addClass('hider-visibe').text(settings.rollDownText);
                toggleBox.show();
            }

            toggleButton.on('click', function() {
                toggleBox.toggle('slow');
                $(this).toggleClass('hider-hidden hider-visible');
                if($(this).is('.hider-hidden')) {
                    $(this).text(settings.rollUpText);
                } else {
                    $(this).text(settings.rollDownText);
                }
            });

            toggleButton.css('cursor', 'pointer');
        }); 
    };
    })( jQuery );


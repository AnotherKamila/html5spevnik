// inspired by https://mootools.lighthouseapp.com/projects/2706/tickets/778-add-hashchange-event
(function($,$$) {
    Element.Events.hashchange = {
        onAdd: function() {
            var hashchange = function(){
                hash = self.location.hash;

                var value = (hash.charAt(0) == '#' ? hash.substr(1) : hash);
                document.fireEvent('hashchange', value);
                window.fireEvent('hashchange', value);
            };

            window.onhashchange = hashchange;
        }
    };
})(document.id,$$);

// inspired by https://mootools.lighthouseapp.com/projects/2706/tickets/778-add-hashchange-event
(function($,$$) {
    Element.Events.hashchange = {
        onAdd: function() {
            var hash = window.location.hash;

            var hashchange = function(){
                if (hash == self.location.hash) return;
                else hash = self.location.hash;

                var value = (hash.indexOf('#') == 0 ? hash.substr(1) : hash);
                document.fireEvent('hashchange', value);
            };

            window.onhashchange = hashchange;
        }
    };
})(document.id,$$);

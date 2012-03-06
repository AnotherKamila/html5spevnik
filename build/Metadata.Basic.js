
  module('BasicMetadata', 'contains defs for title, artist and tags', function() {
    var _ref;
    if ((_ref = S.Metadata) == null) S.Metadata = {};
    S.Metadata.title = {
      name: 'Title',
      tohtml: function(s) {
        return new Element('span.metadata-basic', {
          text: htmlescape(s)
        });
      }
    };
    S.Metadata.artist = {
      name: 'Artist',
      tohtml: function(s) {
        return new Element('span.metadata-basic', {
          text: htmlescape(s)
        });
      }
    };
    return S.Metadata.tags = {
      name: 'Tags',
      tohtml: function(s) {
        var x;
        return new Element('span.metadata-multi'.adopt([
          (function() {
            var _i, _len, _ref2, _results;
            _ref2 = s.split(';');
            _results = [];
            for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
              x = _ref2[_i];
              _results.push(new Element('span.metadata-multi-item', {
                text: htmlescape(x.trim())
              }));
            }
            return _results;
          })()
        ]));
      }
    };
  });

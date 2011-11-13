(function() {
  S.Metadata.register({
    name: 'test',
    friendlyName: 'Test Metadata',
    toHTML: function(value) {
      return value;
    },
    priority: 47
  });
}).call(this);


  S.register('Metadata.Test', function(hooks) {
    var friendlyName, name;
    name = 'test';
    friendlyName = 'Test Metadata';
    return hooks['DB.beforeSetup'] = function(data) {
      return data.addIndexField(name);
    };
  });

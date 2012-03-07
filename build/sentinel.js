
  log('=== Component initialization started ===');

  S.say('allModulesLoaded');

  S.hookto('allModulesLoaded:done', function() {
    return log('=== Initialization finished ===');
  });

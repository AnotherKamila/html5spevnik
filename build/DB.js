
  module('DB', 'database interface on top of IndexedDB', function() {
    var db, debug, getExpectedVersion, indices, _ref;
    debug = true;
    db = null;
    S.hookto('allModulesLoaded', function() {
      return S.say('DB.beforeSetup');
    });
    indices = (_ref = S.Metadata) != null ? _ref : {};
    S.hookto('DB.beforeSetup:done', function() {
      var openReq;
      log('DB: Starting initialization');
      openReq = indexedDB.open('spevnik', 'database for my pretty songbook');
      openReq.onerror = function(e) {
        return err('DB: Cannot open DB:', e);
      };
      return openReq.onsuccess = function(e) {
        var setVReq;
        db = e.target.result;
        if (S.debug) S.DBG.db = db;
        db.onerror = function(e) {
          return err('DB: ', e);
        };
        if (debug) log("DB: Current version: " + db.version);
        if (debug) log("DB: Should be:       " + (getExpectedVersion()));
        if (db.version === getExpectedVersion()) {
          return S.say('DB.ready');
        } else {
          log('DB: initiating setVersion request...');
          setVReq = db.setVersion(getExpectedVersion());
          return setVReq.onsuccess = function(e) {
            var index, store;
            if (db.objectStoreNames.contains('songs')) {
              store = e.target.transaction.objectStore('songs');
            } else {
              if (debug) log('DB: Creating object store...');
              store = db.createObjectStore('songs', {
                keyPath: 'id',
                autoIncrement: true
              });
            }
            for (index in indices) {
              if (!store.indexNames.contains(index)) {
                if (debug) log("DB: Creating index for " + index);
                store.createIndex(index, index, {
                  unique: false
                });
              }
            }
            return S.say('DB.ready');
          };
        }
      };
    });
    return getExpectedVersion = function() {
      var i;
      return S.version + '|' + ((function() {
        var _results;
        _results = [];
        for (i in indices) {
          _results.push(i);
        }
        return _results;
      })()).join(',');
    };
  });


  S.register('DB', function(hooks) {
    var addIndexField, db, debug, getExpectedVersion, indices;
    debug = true;
    db = null;
    hooks['init'] = function() {
      return S.run('DB.beforeSetup', {
        addIndexField: addIndexField
      });
    };
    hooks['DB.beforeSetup:done'] = function() {
      var openReq;
      if (debug) console.log('DB: Initialization started');
      window.indexedDB || (window.indexedDB = webkitIndexedDB || mozIndexedDB || moz_indexedDB);
      openReq = indexedDB.open('spevnik', 'database for my pretty songbook');
      openReq.onerror = function(e) {
        return console.warn('ERR: DB: Cannot open DB: ' + e);
      };
      return openReq.onsuccess = function(e) {
        var setVReq;
        db = e.target.result;
        db.onerror = function(e) {
          return console.warn('ERR: DB: ' + e);
        };
        if (debug) console.log("DB: Current version: " + db.version);
        if (debug) console.log("DB: Should be:       " + (getExpectedVersion()));
        if (db.version !== getExpectedVersion()) {
          console.log('DB: initiating setVersion request...');
          setVReq = db.setVersion(getExpectedVersion());
          return setVReq.onsuccess = function(e) {
            var index, store;
            if (db.objectStoreNames.contains('songs')) {
              store = e.target.transaction.objectStore('songs');
            } else {
              if (debug) console.log('DB: Creating object store...');
              store = db.createObjectStore('songs', {
                keyPath: 'id',
                autoIncrement: true
              });
            }
            for (index in indices) {
              if (debug) console.log("DB: Creating index for " + index);
              store.createIndex(index, index, {
                unique: false
              });
            }
            return S.run('DB.ready');
          };
        } else {
          return S.run('DB.ready');
        }
      };
    };
    addIndexField = function(f) {
      return indices[f] = true;
    };
    indices = {};
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

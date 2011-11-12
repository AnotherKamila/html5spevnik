(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  module('S.DB', function(exports) {
    var addIndexFields, db, debug, getExpectedVersion, indices, init, setupDB;
    debug = true;
    db = null;
    addIndexFields = __bind(function(arr) {
      var item, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = arr.length; _i < _len; _i++) {
        item = arr[_i];
        _results.push(indices[item] = true);
      }
      return _results;
    }, this);
    indices = {};
    init = function() {
      var openReq;
      if (debug) {
        console.log('DB: Initialization started');
      }
      window.indexedDB || (window.indexedDB = webkitIndexedDB || mozIndexedDB || moz_indexedDB);
      openReq = indexedDB.open('spevnik', 'database for my pretty songbook');
      openReq.onerror = function(e) {
        return console.warn('ERR: DB: Cannot open DB: ' + e);
      };
      return openReq.onsuccess = __bind(function(e) {
        var setVReq;
        db = e.target.result;
        db.onerror = function(e) {
          return console.warn('ERR: DB: ' + e);
        };
        if (debug) {
          console.log("DB: Current version: " + db.version);
        }
        if (debug) {
          console.log("DB: Should be: " + (getExpectedVersion()));
        }
        if (db.version !== getExpectedVersion()) {
          setVReq = db.setVersion(getExpectedVersion());
          return setVReq.onsuccess = setupDB;
        } else {
          return S.fireEvent('DB.ready');
        }
      }, this);
    };
    setupDB = function(e) {
      var index, store;
      if (!db.objectStoreNames.contains('songs')) {
        console.log('Creating object store...');
        store = db.createObjectStore('songs', {
          keyPath: 'id',
          autoIncrement: true
        });
      }
      for (index in indices) {
        if (debug) {
          console.log("DB: Creating index for " + index);
        }
        store.createIndex(index, index, {
          unique: false
        });
      }
      return S.fireEvent('DB.ready');
    };
    getExpectedVersion = function() {
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
    S.onEvent('DB.beforeSetup:done', init);
    return S.onEvent('allModulesLoaded', function() {
      return S.fireEvent('DB.beforeSetup', {
        addIndexFields: addIndexFields
      });
    });
  });
}).call(this);

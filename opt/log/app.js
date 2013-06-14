'use strict';

var temp   = require('temp')
  , fs     = require('fs')
  , slug   = require('slugg')
  , q      = require('q')
  , spawn  = require('child_process').spawn
  , mkdirp = require('mkdirp')
  , _      = require('lodash')
  , editor = process.env.EDITOR || 'vi'
  , dir    = process.env.PERSONAL_LOG_DIR
  , mode   = parseInt(process.env.PERSONAL_LOG_MODE || '0600')
;

getEntry().then(saveEntry).then(
    function(path) {
        console.log('Log created: '+ path);
        process.exit(0);
    },
    function(err) {
        console.log(err && (err.message || err));
        process.exit(1);
    }
);

function getEntry() {
    var info = q.nfcall(temp.open, {
        prefix: 'log-',
        suffix: '.markdown'
    });

    var path = info.then(function(i) { return i.path; });
    var created = readAttr(info, 'mtime');

    var editProc = path.then(function(p) {
        var deferred = q.defer()
          , proc = spawn(editor, [p], { stdio: 'inherit' });
        proc.on('close', deferred.resolve);
        return deferred.promise;
    });

    var modified = editProc.then(function() {
        return readAttr(info, 'mtime');
    });

    return q.all([created, modified]).then(function(ts) {
        if (ts[1] <= ts[0]) {
            throw new Error('Log cancelled by user.');
        }
        return path;
    });
}

function saveEntry(inPath) {
    var created = new Date()
      , d       = logdir(created)
      , outPath = q.nfcall(fs.readFile, inPath, 'utf8').then(_.partial(logname, created));

    return q.all([q.nfcall(mkdirp, d), outPath]).then(function(ps) {
        var out = ps[1];
        return copy(inPath, out).then(function() {
            return out;
        });
    });
}

function readAttr(info, attr) {
    return info.then(function(i) {
        return q.nfcall(fs.fstat, i.fd).then(function(s) {
            return s[attr];
        });
    });
}

function copy(from, to) {
    var source   = fs.createReadStream(from)
      , sink     = fs.createWriteStream(to)
      , deferred = q.defer();
    source.pipe(sink);
    source.on('end', deferred.resolve);
    return deferred.promise;
}

function logdir(date) {
    return dir.replace(/\/$/, '') +'/'+ date.getUTCFullYear();
}

function logname(date, data) {
    return logdir(date) +'/'+ title(date, data);
}

function title(date, data) {
    var stamp = datestamp(date)
      , line  = (data.match(/^(.*)(?:\n|$)/) || [])[1];
    return stamp + (line ? '_'+ slug(line.slice(0, 50)) : '');
}

function datestamp(d) {
    return d.toISOString().slice(0,16).replace(':', '') + 'Z';
}

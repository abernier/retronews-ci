var async = require('async');
var conf = require('../../conf');

function scenario(browser, test) {
  test("test2", function (t) {
    t.plan(1);

    async.waterfall([
      function (cb) {browser.get('http://google.com', cb);},

      function (cb) {browser.title(cb);},
      function (title, cb) {t.ok(title === 'Google', 'title is ok'); cb(null)}
    ], function (er) {
      if (er) return t.threw(er);

      t.end();
    });
  });
}

module.exports = scenario;
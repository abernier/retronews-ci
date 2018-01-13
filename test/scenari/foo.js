var async = require('async');
var conf = require('../../conf');

function scenario(browser, test) {
  test("test1", function (t) {
    t.plan(1);

    async.waterfall([
      function (cb) {browser.get('https://www.google.com', cb);},

      function (cb) {browser.title(cb);},
      function (title, cb) {t.ok(title === 'Google', 'title is ok'); cb(null)},
      
      //function (cb) {browser.elementByCssSelector('h1', cb);},
      //function (el, cb) {t.ok(el, 'h1 found on homepage'); cb(null, el);}
    ], function (er) {
      if (er) return t.threw(er);

      t.end();
    });
  });

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
require('node-jsx').install()
require('tap').test('render layout', function (t) {
  t.plan(1)
  var React = require('react')
  var Layout = require('../')
  var TestLayout = require('../example/app-layout')

  var expected = '<div style="height:900px;width:1400px;"><div class="sidebar" style="height:900px;width:330px;"><div>sidebar view</div></div><div class="main" style="height:900px;width:1070px;"><div>main view</div></div></div>'

  var rendered = React.renderToStaticMarkup(React.createElement(TestLayout, {
    sidebar: React.DOM.div(null, 'sidebar view'),
    main: React.DOM.div(null, 'main view'),
    width: 1400,
    height: 900,
  }))
  t.equal(rendered, expected, 'rendered output should equal expected output')
})

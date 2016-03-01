# React Layout

Dynamic subview layout for [React](http://facebook.github.io/react/)

Define layout of nested views with fixed and flexible dimensions in a declarative manner.

Why? If you still have to support IE9 and below, flexbox is off the table. However, flexibly sized elements are necessary for many complex layouts.

### Example
```js
var React = require('react')
var Layout = require('react-layout')
var AppViews = require('./app-views')

var AppLayout = React.createClass({
  getInitialState: function() {
    // a resizable sidebar could be implemented by updating this value
    return {sidebarWidth: 330}
  },
  render: function() {
    var scrollable = {
      'overflow-y': 'scroll',
      'overflow-x': 'hidden',
    }

    return (
      <Layout layoutWidth={this.props.width} layoutHeight={this.props.height}>
        <Layout className="sidebar" layoutWidth={this.state.sidebarWidth}>
          <AppViews.Sidebar />
        </Layout>
        <Layout className="main" layoutWidth="flex" style={scrollable}>
          <AppViews.Main />
        </Layout>
      </Layout>
    )
  },
})

function render() {
  var appView = (
    <AppLayout
      width={window.innerWidth}
      height={window.innerHeight}
    />
  )
  React.render(appView, document.body)
}

window.addEventListener('resize', render)

render()
```

This example implements a two-panel app layout with a sidebar and main viewport.
The sidebar gets its width from a state value and the main view fills the
remaining width.

When the window is resized, the app is rerendered and the new window dimensions
flow down the layout hierarchy.

### API

The `Layout` component provided by this module can be parametised with the props
`layoutWidth` and `layoutHeight`, both which take a `layoutDef` value, which can
be any of the following:
- numeric pixel value eg. `layoutHeight={100}`: will apply a fixed size in pixels 
  for that dimension
- `"flex"`: will fill the remaining space left by fixed size sibling `Layout`
  elements  components taking part in layout for that dimension. If there are
  multiple 'flex' components, they will share the available space evenly.
- `"omit"`: the element will not be given any size value for this dimension

If no `layoutDef` value is provided for a particular dimension, the `Layout`
component will inherit the size for that dimension from the parent component
(or the closest parent `Layout` component) as a fixed size.

Other props:

- `component`: a React component class to use for the layout element (defaults to `div`)

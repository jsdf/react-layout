# React Layout

Dynamic subview layout for [React](http://facebook.github.io/react/)

Define layout of nested views with fixed and flexible dimensions in a declarative format.

### API

Props supported on Layout components:

`layoutWidth`, `layoutHeight`: 'inherit', 'flex', or an numeric size in pixels. 
- a numeric size will apply a fixed size in pixels for that dimension
- 'inherit' will inherit the size for that dimension from the parent component (or the closest parent Layout component) and apply it as a fixed size
- 'flex' will apply a size which is equal to the remaining pixels which aren't taken up by all the fixed sized sibling components taking part in layout for that dimension. If there are multiple 'flex' components, they will share the available size.

### example

```html
React = require('react');
Layout = require('react-layout');

var AppLayout = React.createClass({
  getInitialState: function() {
    return { sidebarWidth: 330 };
  },
  render: function() {
    var regions = this.props.regions;
    var sidebarWidth = this.state.sidebarWidth;

    var scrollable = {
      'overflow-y': 'scroll',
      'overflow-x': 'hidden',
    };

    return (
      <Layout className="app" layoutWidth="inherit" layoutHeight="inherit">
        <Layout className="sidebar" layoutWidth={sidebarWidth} layoutHeight="inherit" style={scrollable}>
          {regions.sidebar}
        </Layout>
        <Layout className="main" layoutWidth="flex" layoutHeight="inherit">
          {regions.main}
        </Layout>
      </Layout>
    );
  },
});
```


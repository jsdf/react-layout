var React = require('react')
var Layout = require('../')

var AppLayout = React.createClass({
  getInitialState: function() {
    return { sidebarWidth: 330 }
  },
  render: function() {
    return (
      <Layout layoutWidth={this.props.width} layoutHeight={this.props.height}>
        <Layout className="sidebar" layoutWidth={this.state.sidebarWidth}>
          {this.props.sidebar}
        </Layout>
        <Layout className="main" layoutWidth="flex">
          {this.props.main}
        </Layout>
      </Layout>
    )
  },
})

module.exports = AppLayout

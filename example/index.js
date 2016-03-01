var React = require('react');
var ReactDOM = require('react-dom');
var Layout = require('../');

var VerticalLayout = React.createClass({
  render: function() {
    return (
      <Layout layoutWidth={this.props.width} layoutHeight={this.props.height}>
        <Layout className="nav" layoutHeight={100}>
          <div>nav</div>
        </Layout>
        <Layout layoutHeight="flex">
          <Layout className="sidebar" layoutWidth={300} style={{float: 'left'}}>
            <div>Sidebar</div>
          </Layout>
          <Layout className="main" layoutWidth="flex" style={{float: 'right'}}>
            <div>Main</div>
            <textarea ref={(c) => c && c.focus()} />
          </Layout>
        </Layout>
      </Layout>
    )
  }
})

function render() {
  var appView = (
    <VerticalLayout
      width={window.innerWidth}
      height={window.innerHeight}
    />
  )
  ReactDOM.render(appView, document.getElementById('root'))
}

window.addEventListener('resize', render)

render()

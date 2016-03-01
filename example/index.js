var React = require('react');
var ReactDOM = require('react-dom');
var Layout = require('../');

var VerticalLayout = React.createClass({
  render: function() {
    return (
      <Layout layoutWidth={this.props.width} layoutHeight={this.props.height}>
        <Layout className="nav" layoutHeight={100} style={{background: 'pink'}}>
          <div>nav</div>
          <input type='text' />
        </Layout>
        <Layout layoutHeight='flex'>
          <Layout className="sidebar" layoutWidth={300} style={{background: 'darkblue', float: 'left'}}>
            <div>Sidebar</div>
          </Layout>
          <Layout className="main" layoutWidth="flex" style={{background: 'lightgreen', float: 'right'}}>
            <div>Main</div>
            <input type='text' ref={(c) => c.focus()} />
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
  ReactDOM.render(appView, document.body)
}

window.addEventListener('resize', render)

render()

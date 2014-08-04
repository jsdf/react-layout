React = require('react')

merge = require('xtend')

LayoutMixin = require('./mixin')

Layout = React.createClass
  displayName: 'Layout',
  mixins: [
    LayoutMixin,
  ]

  getDefaultProps: ->
    component: React.DOM.div

  render: ->
    {component, style} = @props

    extraProps = {}
    extraProps.style = merge(style or {}, @getLocalLayout())

    unless @props.innerChild
      extraProps.children = @applyLayoutToChildren(@props.children)

    component(merge(@props, extraProps))

module.exports = Layout

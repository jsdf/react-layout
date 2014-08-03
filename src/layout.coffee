React = require('react')

merge = require('xtend')

ContextLayoutMixin = require('./mixin')

Layout = React.createClass
  displayName: 'ContextLayout',
  mixins: [
    ContextLayoutMixin,
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


React = require('react/addons')

merge = clone = require('xtend')

DIMENSIONS = ['height','width']

ContextLayoutMixin = 
  contextTypes: 
    layoutContext: React.PropTypes.object,
 
  childContextTypes: 
    layoutContext: React.PropTypes.object,

  getChildContext: ->   
    layoutContext: @getLayoutContext(),
  
  getLayoutContext: ->
    @props.layoutContext or @context.layoutContext

  # get layout for this node, assuming appropriate calculations were done by parent
  getLocalLayout: ->
    local = {}
    layoutContext = @getLayoutContext()

    def = getLayoutDef(this)
    return local unless def
    DIMENSIONS.forEach (dim) ->
      local[dim] = layoutContext[dim] if def[dim]
    local

  applyLayoutToChildren: (children) ->
    parentLayout = @getLayoutContext()
    unless parentLayout.height? and parentLayout.width?
      throw new Error('missing parent layout')

    # precalc stuff for each dimension
    precalc = DIMENSIONS.reduce((precalc, dim) ->
      precalc[dim] =
        fixedSum: 0
        flexChildren: 0
      precalc
    , {})
    React.Children.forEach children, (child) ->
      def = getLayoutDef(child)
      return unless def
      DIMENSIONS.forEach (dim) ->
        if layoutIsFixed(def[dim])
          precalc[dim].fixedSum += def[dim]
        else if layoutIsFlex(def[dim])
          precalc[dim].flexChildren++
       
    # calc and apply layout to each child
    React.Children.map children, (child) ->
      # the calculated layout for the child,
      # which will transclude the layoutContext for it and its children
      layout = clone(parentLayout)
      def = getLayoutDef(child)
      if def
        DIMENSIONS.forEach (dim) ->
          if layoutIsFixed(def[dim])
            layout[dim] = def[dim]
          else if layoutIsFlex(def[dim])
            flexSizeForDimension = (parentLayout[dim] - precalc[dim].fixedSum) / precalc[dim].flexChildren
            layout[dim] = flexSizeForDimension
          # else if layoutIsInherited(def[dim])
          #   layout[dim] = parentLayout[dim]
          # else # dim omitted

      React.addons.cloneWithProps child, layoutContext: layout

getLayoutDef = (component) ->
  return unless component.props.layoutHeight or component.props.layoutWidth
  height: component.props.layoutHeight
  width: component.props.layoutWidth

layoutIsFixed = (value) -> typeof value is 'number'

layoutIsFlex = (value) -> value is 'flex'

layoutIsInherited = (value) -> value is 'inherit'

module.exports = ContextLayoutMixin


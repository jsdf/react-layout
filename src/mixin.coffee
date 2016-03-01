
React = require('react')

merge = clone = require('xtend')

DIMENSIONS = ['height','width']

LayoutMixin =
  contextTypes:
    layoutContext: React.PropTypes.object,

  childContextTypes:
    layoutContext: React.PropTypes.object,

  getChildContext: ->
    layoutContext: @getLayoutContext(),

  getLayoutContext: ->
    inherited = @props.layoutContext or @context.layoutContext
    if inherited?
      inherited
    else
     width: if isNumber(@props.layoutWidth) then @props.layoutWidth
     height: if isNumber(@props.layoutHeight) then @props.layoutHeight

  # get layout for this node, assuming appropriate calculations were done by parent
  getLocalLayout: ->
    local = {}
    layoutContext = @getLayoutContext()
    guardLayoutContext(layoutContext)

    def = getLayoutDef(this)
    return local unless def
    DIMENSIONS.forEach (dim) ->
      local[dim] = layoutContext[dim] if def[dim]
    local

  applyLayoutToChildren: (children) ->
    parentLayout = @getLayoutContext()
    guardLayoutContext(parentLayout)

    # first pass calculations for each dimension
    precalc = DIMENSIONS.reduce((precalc, dim) ->
      precalc[dim] =
        fixedSum: 0
        flexChildren: 0
      precalc
    , {})
    React.Children.forEach children, (child) ->
      return unless child
      def = getLayoutDef(child)
      return unless def
      DIMENSIONS.forEach (dim) ->
        if layoutIsFixed(def[dim])
          precalc[dim].fixedSum += def[dim]
        else if layoutIsFlex(def[dim])
          precalc[dim].flexChildren++

    # calc and apply layout to each child
    React.Children.map children, (child) ->
      # only apply to component-like objects (which have props)
      return child unless child?.props
      # 'layout' here refers to the calculated layout for the child,
      # which will inform that child's layoutContext
      # (and any of its children which inherit it)
      layout = clone(parentLayout)
      def = getLayoutDef(child)
      if def
        DIMENSIONS.forEach (dim) ->
          if layoutIsFixed(def[dim])
            layout[dim] = def[dim]
          else if layoutIsFlex(def[dim])
            flexSizeForDimension = (parentLayout[dim] - precalc[dim].fixedSum) / precalc[dim].flexChildren
            layout[dim] = flexSizeForDimension

      React.cloneElement child, layoutContext: layout

getLayoutDef = (component) ->
  return unless hasReactLayout(component)

  def =
    height: component.props.layoutHeight
    width: component.props.layoutWidth

  def.height ?= 'inherit'
  def.width ?= 'inherit'

  def

guardLayoutContext = (layoutContext) ->
  assert(layoutContext,'layoutContext')
  assert(layoutContext.height,'layoutContext.height')
  assert(layoutContext.width,'layoutContext.width')

hasReactLayout = (component) ->
  # must specify hasReactLayout or have at least one layout prop to be taking part in layout
  component.props?.layoutHeight or component.props?.layoutWidth or \
  component.hasReactLayout or component.constructor?.hasReactLayout or component.type?.hasReactLayout

layoutIsFixed = (value) -> typeof value is 'number'

layoutIsFlex = (value) -> value is 'flex'

layoutIsOmitted = (value) -> value is 'omit'

layoutIsInherited = (value) -> value is 'inherit' or not (layoutIsFixed(value) or layoutIsFlex(value) or layoutIsOmitted(value))

assert = (value, name) -> throw new Error("missing #{name}") unless value?

isNumber = (value) -> typeof value is 'number'

module.exports = LayoutMixin

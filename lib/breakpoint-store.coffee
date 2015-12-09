{CompositeDisposable} = require 'atom'
module.exports =
class BreakpointStore
  constructor: (gutter) ->
    @breakpoints = []

  toggle: (breakpoint) ->
    breakpointSearched = @containsBreakpoint(breakpoint)

    addDecoration = true
    if(breakpointSearched)
      @breakpoints.splice(breakpointSearched, 1)
      addDecoration = false
    else
      @breakpoints.push(breakpoint)

    if addDecoration
      editor = atom.workspace.getActiveTextEditor()
      marker = editor.markBufferPosition([breakpoint.lineNumber-1, 0])
      d = editor.decorateMarker(marker, type: 'line-number', class: 'line-number-green')
      d.setProperties(type: 'line-number', class: 'line-number-green')
      breakpoint.decoration = d
    else
      breakpointSearched.decoration.getMarker().destroy()

  containsBreakpoint: (bp) ->
    for breakpoint in @breakpoints
      if breakpoint.filename == bp.filename && breakpoint.lineNumber == bp.lineNumber
        return breakpoint
    return null

  currentBreakpoints: ->
    for breakpoint in @breakpoints
      console.log breakpoint

  clear: () ->
    @breakpoints = []

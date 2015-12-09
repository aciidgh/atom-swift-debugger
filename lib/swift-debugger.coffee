{CompositeDisposable} = require 'atom'
Breakpoint = require './breakpoint'
BreakpointStore = require './breakpoint-store'

module.exports = SwiftDebugger =
  swiftDebuggerView: null
  subscriptions: null

  createDebuggerView: (lldb) ->
    unless @swiftDebuggerView?
      SwiftDebuggerView = require './swift-debugger-view'
      @swiftDebuggerView = new SwiftDebuggerView(@breakpointStore)
    @swiftDebuggerView

  activate: ({attached}={}) ->

    @subscriptions = new CompositeDisposable
    @breakpointGutter = atom.workspace.getActiveTextEditor().addGutter name: 'breakpoints'
    @breakpointStore = new BreakpointStore(@breakpointGutter)
    @createDebuggerView().toggle() if attached

    @subscriptions.add atom.commands.add 'atom-workspace',
      'swift-debugger:toggle': => @createDebuggerView().toggle()
      'swift-debugger:breakpoint': => @toggleBreakpoint()

  toggleBreakpoint: ->
    editor = atom.workspace.getActiveTextEditor()
    filename = editor.getTitle()
    lineNumber = editor.getCursorBufferPosition().row + 1
    breakpoint = new Breakpoint(filename, lineNumber)
    @breakpointStore.toggle(breakpoint)

  deactivate: ->
    @lldbInputView.destroy()
    @subscriptions.dispose()
    @swiftDebuggerView.destroy()

  serialize: ->
    swiftDebuggerViewState: @swiftDebuggerView.serialize()

    # console.log 'SwiftDebugger was toggled!'
    # shell = atom.config.get('run-command.shellCommand') || '/bin/bash'
    # editor = atom.workspace.getActiveTextEditor()
    # activePath = editor?.getPath()
    # relative = atom.project.relativizePath(activePath)
    # themPaths = relative[0] || path.dirname(activePath)
    #
    # console.log themPaths

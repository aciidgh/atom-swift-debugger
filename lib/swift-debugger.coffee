{CompositeDisposable} = require 'atom'
LldbInputView = require './lldb-input-view'
spawn = require('child_process').spawn

module.exports = SwiftDebugger =
  swiftDebuggerView: null
  modalPanel: null
  subscriptions: null

  createDebuggerView: (lldb) ->
    unless @swiftDebuggerView?
      SwiftDebuggerView = require './swift-debugger-view'
      @swiftDebuggerView = new SwiftDebuggerView(@lldb)
    @swiftDebuggerView

  activate: ({attached}={}) ->
    @lldb = spawn 'lldb', ['/Users/aciid/mycode/CoffeeDemo/swift/hello']
    @createDebuggerView(@lldb).toggle() if attached
    @lldb.stdout.on 'data',(data) =>
      @swiftDebuggerView.addOutput(data.toString().trim())
    @lldb.stderr.on 'data',(data) =>
      @swiftDebuggerView.addOutput(data.toString().trim())
    @lldb.on 'exit',(code) ->
      console.log "exit code:" + code

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace',
      'swift-debugger:toggle': => @createDebuggerView().toggle()
      # 'swift-debugger:lldb-shell': => @runLLDBCommand()
      # 'swift-debugger:run-program': => @runSwiftProgram()

  runSwiftProgram: ->
    @lldb.stdin.write("r\n")

  runLLDBCommand: ->
    @lldbInputView.show()
    console.log "have to run command now"
    # @lldb.stdin.write("breakpoint set -f hello.swift -l 2\n")

  deactivate: ->
    @lldbInputView.destroy()
    @modalPanel.destroy()
    @subscriptions.dispose()
    @swiftDebuggerView.destroy()

  serialize: ->
    swiftDebuggerViewState: @swiftDebuggerView.serialize()

  toggle: ->
    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()
    # console.log 'SwiftDebugger was toggled!'
    # shell = atom.config.get('run-command.shellCommand') || '/bin/bash'
    # editor = atom.workspace.getActiveTextEditor()
    # activePath = editor?.getPath()
    # relative = atom.project.relativizePath(activePath)
    # themPaths = relative[0] || path.dirname(activePath)
    #
    # console.log themPaths

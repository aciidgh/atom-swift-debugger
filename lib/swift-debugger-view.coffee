{Disposable, CompositeDisposable} = require 'atom'
{$, $$, View, TextEditorView} = require 'atom-space-pen-views'
Breakpoint = require './breakpoint'
BreakpointStore = require './breakpoint-store'

spawn = require('child_process').spawn
path = require 'path'
module.exports =
class SwiftDebuggerView extends View
  executableFileName: null
  swiftPath: null

  @content: ->
    @div class: 'swiftDebuggerView', =>
      @subview 'commandEntryView', new TextEditorView
        mini: true,
        placeholderText: 'po foo'
      @button outlet: 'runBtn', click: 'runApp', class: 'btn', =>
        @span 'run'
      @button outlet: 'stopBtn', click: 'stopApp', class: 'btn', =>
        @span 'stop'
      @button outlet: 'cleatBtn', click: 'clearOutput', class: 'btn', =>
        @span 'clear'
      @button outlet: 'stepOver', click: 'stepOverBtnPressed', class: 'btn', =>
        @span 'next line'
      @button outlet: 'resume', click: 'resumeBtnPressed', class: 'btn', =>
        @span 'resume'
      @div class: 'panel-body', outlet: 'outputContainer', =>
        @pre class: 'command-output', outlet: 'output'

  stepOverBtnPressed: ->
    @lldb.stdin.write("n\n")

  resumeBtnPressed: ->
    @lldb.stdin.write("c\n")

  workspacePath: ->
    editor = atom.workspace.getActiveTextEditor()
    activePath = editor.getPath()
    relative = atom.project.relativizePath(activePath)
    pathToWorkspace = relative[0] || path.dirname(activePath)
    pathToWorkspace

  runApp: ->
    if(@lldb)
      @stopApp

    if(@pathsNotSet())
      @askForPaths()
      return

    @swiftBuild = spawn @swiftPath+'/swift', ['build', '--chdir', @workspacePath()]
    @swiftBuild.stdout.on 'data',(data) =>
      @addOutput(data.toString().trim())
    @swiftBuild.stderr.on 'data',(data) =>
      @addOutput(data.toString().trim())
    @swiftBuild.on 'exit',(code) =>
      codeString = code.toString().trim()
      if codeString == '0'
        @runLLDB()
      @addOutput("built with code : " + codeString)

  runLLDB: ->
    @lldb = spawn @swiftPath+"/lldb", [@workspacePath()+"/.build/debug/"+@executableFileName]

    for breakpoint in @breakpointStore.breakpoints
      @lldb.stdin.write(breakpoint.toCommand()+'\n')

    @lldb.stdin.write('r\n')
    @lldb.stdout.on 'data',(data) =>
      @addOutput(data.toString().trim())
    @lldb.stderr.on 'data',(data) =>
      @addOutput(data.toString().trim())
    @lldb.on 'exit',(code) =>
      @addOutput("exit code: " + code.toString().trim())

  stopApp: ->
    @lldb.stdin.write("\nexit\n")

  clearOutput: ->
    @output.empty()

  createOutputNode: (text) ->
    node = $('<span />').text(text)
    parent = $('<span />').append(node)

  addOutput: (data) ->
    atBottom = @atBottomOfOutput()
    node = @createOutputNode(data)
    @output.append(node)
    @output.append("\n")
    if atBottom
      @scrollToBottomOfOutput()

  pathsNotSet: ->
    !@swiftPath || !@executableFileName

  askForPaths: ->
    if @pathsNotSet()
      @addOutput("Please enter executable and swift path using e=nameOfExecutable then p=path/to/swift")
      @addOutput("Example e=helloWorld")
      @addOutput("Example p=/Library/Developer/Toolchains/swift-latest.xctoolchain/usr/bin")

  initialize: (breakpointStore) ->
    @breakpointStore = breakpointStore
    @addOutput("Welcome to Swift Debugger")
    @askForPaths()
    @subscriptions = atom.commands.add @element,
      'core:confirm': (event) =>
        if @parseAndSetPaths()
          @clearInputText()
        else
          @confirmLLDBCommand()
        event.stopPropagation()
      'core:cancel': (event) =>
        @cancelLLDBCommand()
        event.stopPropagation()

  parseAndSetPaths:() ->
    command = @getCommand()
    if !command
      return false
    if /e=(.*)/.test command
      match = /e=(.*)/.exec command
      @executableFileName = match[1]
      @addOutput("executable path set")
      return true
    if /p=(.*)/.test command
      match = /p=(.*)/.exec command
      @swiftPath = match[1]
      @addOutput("swift path set")
      return true
    return false

  stringIsBlank: (str) ->
    !str or /^\s*$/.test str

  getCommand: ->
    command = @commandEntryView.getModel().getText()
    if(!@stringIsBlank(command))
      command

  cancelLLDBCommand: ->
    @commandEntryView.getModel().setText("")

  confirmLLDBCommand: ->
    if !@lldb
      @addOutput("Program not running")
      return
    command = @getCommand()
    if(command)
      @lldb.stdin.write(command + "\n")
      @clearInputText()

  clearInputText: ->
    @commandEntryView.getModel().setText("")

  serialize: ->
    attached: @panel?.isVisible()

  destroy: ->
    @detach()

  toggle: ->
    if @panel?.isVisible()
      @detach()
    else
      @attach()

  atBottomOfOutput: ->
    @output[0].scrollHeight <= @output.scrollTop() + @output.outerHeight()

  scrollToBottomOfOutput: ->
    @output.scrollToBottom()

  attach: ->
    console.log "attach called"
    @panel = atom.workspace.addBottomPanel(item: this)
    @panel.show()
    @scrollToBottomOfOutput()

  detach: ->
    console.log "detach"
    @panel.destroy()
    @panel = null

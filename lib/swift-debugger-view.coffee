{Disposable, CompositeDisposable} = require 'atom'
{$, $$, View, TextEditorView, ScrollView} = require 'atom-space-pen-views'
path = require 'path'

module.exports =
class SwiftDebuggerView extends View
  @content: ->
    #
    @div class: 'swiftDebuggerView', =>
      @subview 'commandEntryView', new TextEditorView
        mini: true,
        placeholderText: 'po foo'
       @button outlet: 'runBtn', click: 'runApp', class: 'btn', =>
         @span 'run'
       @button outlet: 'cleatBtn', click: 'clearOutput', class: 'btn', =>
         @span 'clear'
      @div class: 'panel-body', outlet: 'outputContainer', =>
        @pre class: 'command-output', outlet: 'output'

  runApp: ->
    @addOutput("Trying to build app...")

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

  initialize: ->
    console.log "initialized"
    @addOutput("Welcome to Swift Debugger")

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

{Disposable, CompositeDisposable} = require 'atom'
{$, $$, View, TextEditorView, ScrollView} = require 'atom-space-pen-views'
path = require 'path'

module.exports =
class SwiftDebuggerView extends View
  @content: ->
    @div class: 'swiftDebuggerView', =>
      @subview 'commandEntryView', new TextEditorView
        mini: true,
        placeholderText: 'po foo'
      @div class: 'panel-body', outlet: 'outputContainer', =>
        @pre class: 'command-output', outlet: 'output'

  clearOutput: ->
    @output.empty()

  createOutputNode: (text) ->
    node = $('<span />').text(text)
    parent = $('<span />').append(node)

  addOutput: (data) ->
    atBottom = @atBottomOfOutput()
    node = @createOutputNode(data)
    @output.append(node)
    if atBottom
      @scrollToBottomOfOutput()

  initialize: ->
    console.log "initialized"
    @addOutput("something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something something ")

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

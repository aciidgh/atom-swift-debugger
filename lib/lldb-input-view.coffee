{$, View, TextEditorView} = require 'atom-space-pen-views'

module.exports =
class LldbInputView extends View
  @content: ->
    @div class: 'command-entry', =>
      @subview 'commandEntryView', new TextEditorView
        mini: true,
        placeholderText: 'rake spec'

  initialize: (lldb) ->
    @panel = atom.workspace.addModalPanel
      item: @,
      visible: false
    @lldb = lldb
    @subscriptions = atom.commands.add @element,
      'core:confirm': (event) =>
        console.log "confirmed"
        # @getCommand()
        command = @commandEntryView.getModel().getText()
        # @lldb.stdin.write("breakpoint set -f hello.swift -l 2\n")
        @runCommands(command)
        # @lldb.stdin.write(command+"\n")
        event.stopPropagation()
      'core:cancel': (event) =>
        @cancel()
        event.stopPropagation()

    @commandEntryView.on 'blur', =>
      @cancel()

  runCommands: (command) ->
    @lldb.stdin.write(command+"\n")

  destroy: ->
    @subscriptions.destroy()

  show: ->
    @panel.show()
    @commandEntryView.focus()
    editor = @commandEntryView.getModel()
    editor.setSelectedBufferRange editor.getBuffer().getRange()

  hide: ->
    @panel.hide()

  isVisible: ->
    @panel.isVisible()

  getCommand: ->
    command = @commandEntryView.getModel().getText()
    console.log 'command is ' + command

  cancel: ->
    @hide()

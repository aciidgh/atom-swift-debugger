module.exports =
class SwiftDebuggerView
  constructor: (serializedState) ->
    # Create root element
    @element = document.createElement('div')
    @element.classList.add('swift-debugger')

    # Create message element
    message = document.createElement('div')
    message.textContent = "iz iteee  The SwiftDebugger package is Alive! It's ALIVE!"
    message.classList.add('message')
    @element.appendChild(message)

  addData: (str) ->
    message = document.createElement('div')
    message.textContent = str
    message.classList.add('message')
    @element.appendChild(message)

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  getElement: ->
    @element

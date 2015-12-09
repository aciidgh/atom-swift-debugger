module.exports =
class Breakpoint
  decoration: null
  constructor: (@filename, @lineNumber) ->
  toCommand: ->
    "b " + @filename + ":" + @lineNumber

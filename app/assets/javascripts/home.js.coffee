# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

class window.Zuck extends Backbone.View
  className: 'head'



  initialize: (@img) ->
    @


  setMouth: (rec) ->
    # rec:  top, left, width, height
    # basicall 

  render: ->
    @$el.html """
      <img src="#{@img}"/>
      <div class='mouth'></div>
    """

    @width = @$('img').width()
    @height = @$('img').height()
    @





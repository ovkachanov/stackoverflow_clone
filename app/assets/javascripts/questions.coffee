# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('.edit_question_link').click (e) ->
    e.preventDefault();
    $('.question').hide();
    $('.edit_question_show').show()

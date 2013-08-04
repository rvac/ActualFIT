# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
#jQuery ->
#$(document).ready(function(){
#  setInterval(function() {
#  $('.dynamic').load('/controller_name/action_name');}, 3000);
#});
@Poller =
  poll: ->
    setTimeout @request, 15000
  request: ->
    $.get($("#MessageContainer").data('url'), after: $('.Message').last().data('id'));
    $.get($("#RemarksTable").data('url'), after: $('.ACTR').last().data('id'));



jQuery ->
  Poller.poll();

# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  dtable = $("#Remarks").dataTable
    sPaginationType: "bootstrap"
    bjQueryUI: true
    iDisplayLength: 5,
    aLengthMenu: [[5, 10, 25, 50, -1], [5, 10, 25, 50, "All"]]
  dtable.fnPageChange 'last'
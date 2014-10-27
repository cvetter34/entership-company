//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require jquery.noty
//= require layouts/bottom
//= require layouts/bottomRight
//= require themes/default
//= require jquery-ui
//= require bootbox
//= require moment
//= require bootstrap-datetimepicker
//= require local_time
//= require validator
//= require strength
//= require helper
//= require deletions

$(function() {
  $( document ).tooltip({
      items: "[title]",
      content: function() {
        var element = $( this );
        var re = /\|([^\|]+)\|/;
        return element.attr( "title" ).replace(
          re,
          '<span class="tooltip-hilite">$1</span>'
        );
      }
    });

  var picker = $('#opens-on-datepicker');

  picker.datetimepicker({
    pickDate: true,
    pickTime: false,
    format: 'YYYY-MM-DD'
  });

  picker = $('#closes-on-datepicker');

  picker.datetimepicker({
    pickDate: true,
    pickTime: false,
    format: 'YYYY-MM-DD'
  });
});

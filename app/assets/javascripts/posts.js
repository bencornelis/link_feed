$(document).on('turbolinks:load', function() {
  $(".post").hover(function() {
    $(this).find(".post_details .more_info").toggle();
  });
});

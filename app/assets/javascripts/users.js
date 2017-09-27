$(document).on('turbolinks:load', function() {
  $('.users.show, .profiles.show').ready(function() {
    var user_path = window.location.pathname;

    $.ajax({
      url: user_path,
      dataType: 'script',
      beforeSend: function() {
        $('#user_loader').spin({top: '50%', left: '50%'});
      }
    });
  });
});
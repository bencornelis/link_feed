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

// prevent turbolinks from caching user activity details
$(document).on('turbolinks:before-cache', function() {
  $('#recent_posts, #recent_shared_posts, #recent_comments').html('');
});

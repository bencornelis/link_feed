$(document).on('turbolinks:load', function() {
  $('.post').hover(function() {
    $(this).find('.post_details .more_info').fadeToggle('fast');
  });

  attachCommentHover();

  $('#post_main').hover(function() {
    $(this).find('#post_badge_link, #post_shares').fadeToggle('fast');
  });

  $('form#new_post').ready(function() {
    $('.tag_input').select2({
      tags: true,
      placeholder: 'Select tags',
      ajax: {
        url: '/tags',
        dataType: 'json',
        processResults: function(data) {
          return {
            results: data
          }
        }
      }
    });
  });

  $('.posts.show #comments').ready(function() {
    var commentsCount = parseInt($('#comments_count').text());
    if (commentsCount < 10) {
      attachCommentToggler();
      return;
    }

    // otherwise, load the comments
    var post_path = window.location.pathname;
    $.ajax({
      url: post_path,
      cache: false,
      dataType: 'script',
      beforeSend: function() {
        $('#comments_loader').spin({top: '40%', left: '50%'});;
      },
      success: function() {
        $('#comments_loader').spin(false);
        attachCommentListeners();

        // if linking to a comment anchor, scroll to that comment
        if (location.hash) {
          location.href = location.hash;
        }
      }
    });
  });
});

// prevent turbolinks from caching certain things
$(document).on('turbolinks:before-cache', function() {
  $('.posts.show #comments').html('');
  $('.post_details .more_info').hide();
  $.modal.close();
});

function attachCommentListeners() {
  attachCommentToggler();
  attachCommentHover();
}

function attachCommentToggler() {
  $(".comment .comment_toggler").click(function() {
    var $toggler = $(this);
    var symbol = $toggler.text();
    if (symbol == "[+]") {
      $toggler.text("[-]");
    } else {
      $toggler.text("[+]");
    }
    $comment = $toggler.closest(".comment");
    $comment.children(".comment_main").toggle();
    $comment.next("ul.comments").toggle();
    $comment.find(".share_comment_link").toggle();
  });
}

function attachCommentHover() {
  $('.comment').hover(function() {
    $(this).find('.comment_shares, .comment_badge_link').fadeToggle('fast');
  });
}
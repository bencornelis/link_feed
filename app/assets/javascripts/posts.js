$(document).on('turbolinks:load', function() {
  $('.post').hover(function() {
    $(this).find('.post_details .more_info').toggle();
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
        attachCommentToggler();
        $('#comments_loader').spin(false);

        // if linking to a comment anchor, scroll to that comment
        if (location.hash) {
          location.href = location.hash;
        }
      }
    });
  });
});

// prevent turbolinks from caching post comments
$(document).on('turbolinks:before-cache', function() {
  $('.posts.show #comments').html('');
  $('.post_details .more_info').hide();
});

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
$(document).on('turbolinks:load', function() {
  $('.post').hover(function() {
    $(this).find('.post_details .more_info').toggle();
  });

  $('.posts.show').ready(function() {
    var post_path = window.location.pathname;
    $.ajax({
      url: post_path,
      dataType: 'script',
      beforeSend: function() {
        $('#comments_loader').spin({top: '40%', left: '25%'});;
      },
      success: function() {
        attachCommentToggler();
        $('#comments_loader').spin(false);
      }
    });
  });
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
  });
}
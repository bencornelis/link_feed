$(function() {
  $(".post").hover(function() {
    $(this).find(".post_details .more_info").toggle();
  });

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
})

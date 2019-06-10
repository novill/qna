$(document).on('turbolinks:load', function(){
  $('.answers').on('click', '.edit-answer-link', function(e) {
    e.preventDefault();
    $(this).addClass('hidden');
    var answerId = $(this).data('answerId');
    $('form#edit-answer-' + answerId).removeClass('hidden');
  });

  $('.answers').on('ajax:success', function (e) {
    var details = e.detail[0];

    var answer_path = '#answer-' + details['id']

    $(answer_path + ' p.answer_rating').html('Rating ' + details['rating'])
    if (details['current_user_voted']) {
      $(answer_path + ' a.vote_back').removeClass('hidden');
      $(answer_path + ' a.vote').addClass('hidden');
    }
    else {
      $(answer_path + ' a.vote').removeClass('hidden');
      $(answer_path + ' a.vote_back').addClass('hidden');
    }


  });


});
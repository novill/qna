$(document).on('turbolinks:load', function(){
  $('.answers').on('click', '.edit-answer-link', function(e) {
    e.preventDefault();
    $(this).addClass('hidden');
    var answerId = $(this).data('answerId');
    $('form#edit-answer-' + answerId).removeClass('hidden');
  });

  $('.answers').on('ajax:success', function (e) {
    var details = e.detail[0];

    if (details['id']) {
      var answer_path = '#answer-' + details['id']

      $(answer_path + ' p.answer_rating').html('Rating ' + details['rating'])
      if (details['current_user_voted']) {
        $(answer_path + ' a.vote_back').removeClass('hidden');
        $(answer_path + ' a.vote').addClass('hidden');
      } else {
        $(answer_path + ' a.vote').removeClass('hidden');
        $(answer_path + ' a.vote_back').addClass('hidden');
      }
    }
  });

  App.cable.subscriptions.create('AnswersChannel', {
    connected: function() {
      return this.perform('follow', {
        question_id: $('.question').attr('id')
      });
    },
    received: function(server_data) {
      console.log(server_data);
      if (server_data['answer_id']) {
        console.log(server_data);
        $.get("/add_another_answer/" + server_data['answer_id'], function (data) {
          $(".answers").append(data);
        });
      }
    }
  });

});
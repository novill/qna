$(document).on('turbolinks:load', function(){
  $('.edit-question-link').on('click', function(e) {
    e.preventDefault();
    $(this).addClass('hidden');
    $('form.question-edit').removeClass('hidden');
  })

  $('.question ').on('ajax:success', function (e) {
    if (details['rating']) {
      var details = e.detail[0];
      $('p.question_rating').html('Rating ' + details['rating']);
      if (details['current_user_voted']) {
        $('.question a.vote_back').removeClass('hidden');
        $('.question a.vote').addClass('hidden');
      } else {
        $('.question a.vote').removeClass('hidden');
        $('.question a.vote_back').addClass('hidden');
      }
    }
  });

  App.cable.subscriptions.create('QuestionsChannel', {
    connected: function() {
       return this.perform('follow' )
    },
    received: function(data) {
      console.log(data);
      return $('.questions').append(data);
    }
  });
});
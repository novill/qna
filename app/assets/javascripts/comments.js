$(document).on('turbolinks:load', function(){

  App.cable.subscriptions.create('CommentsChannel', {
    connected: function() {
      return this.perform('follow', {
        question_id: gon.question_id
      });
    },
    received: function(server_data) {
      if (server_data['resource_id']) {
          console.log(server_data)
          // $('.answers').append(JST["templates/answer"](server_data))

          $.get("/add_another_answer/" + server_data['answer_id'], function (data) {
            $(".answers").append(data);
          });
        }
        if (server_data['comment_id']) {

        }
      }
    });

});
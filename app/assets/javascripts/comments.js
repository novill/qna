$(document).on('turbolinks:load', function(){

  App.cable.subscriptions.create('CommentsChannel', {
    connected: function() {
      return this.perform('follow', {
        question_id: gon.question_id
      });
    },
    received: function(server_data) {
      if (server_data['comment_resource_id']) {
        if (gon.user_id != server_data['comment_user_id'])
          $('#' + server_data['comment_resource_id'] + ' .comments ul').append(server_data['comment_html'])
        }
      }
    });

});
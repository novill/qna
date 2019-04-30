$(document).on('turbolinks:load', function(){
  $('.edit-question-link').on('click', function(e) {
    e.preventDefault();
    $(this).addClass('hidden');
    $('form.question-edit').removeClass('hidden');
  })
});
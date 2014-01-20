$( function() {

  $('input#copy_book_reference').click( function() {
    $(this).parents('fieldset.copy-number').find("input[type='radio']").prop('checked', true);
  });

})

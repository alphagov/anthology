var BookLookup = { }

BookLookup.find_by_isbn = function(isbn, success, failure) {
  $.getJSON('/books/isbn/'+ encodeURI(isbn), function(data) {
    if (data.title !== null) {
      success(data);
    } else {
      failure();
    }
  });
}

BookLookup.find_and_render = function(isbn) {
  if (isbn == "") {
    $('#book-placeholder').html('');
    return;
  }

  $('#book-placeholder').addClass('loading').html('Searching for book...');
  BookLookup.find_by_isbn(isbn, function(data){
    output = Mustache.render($('#book-preview-template').html(), data);
    $('#book-placeholder').removeClass('loading').html( output );
  }, function() {
    $('#book-placeholder').html( 'No book found for this ISBN.' );
  });
}

$(document).ready(function() {
  if ($('#book_isbn').length > 0) {
    var book_lookup_timeout;
    var previous_query = '';

    $('#new_book input[name=commit]').remove();

    $('#book_isbn').keyup( function(e) {
      var isbn = $('#book_isbn').val();

      if (isbn !== previous_query) {
        $('#book-placeholder').addClass('loading').html('Searching for book...');

        clearTimeout(book_lookup_timeout);
        book_lookup_timeout = setTimeout(function() {
          previous_query = isbn;
          BookLookup.find_and_render(isbn);
        }, 500);
      }
    });

    var isbn = $('#book_isbn').val();
    if (isbn != '') {
      BookLookup.find_and_render(isbn);
    }
  }
});

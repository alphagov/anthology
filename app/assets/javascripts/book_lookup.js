var BookLookup = { }

BookLookup.find_by_isbn = function(isbn, callback) {
  $.getJSON('/books/isbn/'+ encodeURI(isbn), callback);
}

BookLookup.find_and_render = function(isbn) {
  if (isbn == "") {
    $('#book-preview').html('');
    return;
  }

  $('#book-preview').addClass('loading').html('Searching for book...');
  BookLookup.find_by_isbn(isbn, function(data){
    output = Mustache.render($('#book-preview-template').html(), data);
    $('#book-preview').removeClass('loading').html( output );
  });
}

$(document).ready(function() {
  var book_lookup_timeout;

  $('#book_isbn').keyup( function() {
    var isbn = $('#book_isbn').val();

    clearTimeout(book_lookup_timeout);
    book_lookup_timeout = setTimeout(function() {
      BookLookup.find_and_render(isbn);
    }, 500);
  });

  var isbn = $('#book_isbn').val();
  if (isbn != '') {
    BookLookup.find_and_render(isbn);
  }
});

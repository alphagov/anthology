module BooksHelper
  def book_cover_tag(book, options = { })
    size = options[:size] || "S"
    zoom = cover_sizes[size]

    if book.google_id
      image_tag "http://bks0.books.google.co.uk/books?id=#{book.google_id}&printsec=frontcover&img=1&zoom=#{zoom}&edge=none&source=gbs_api", :alt => "#{book.title} by #{book.author}"
    else
      content_tag :div, :class => "placeholder_book" do
        concat(book.title)
        concat(content_tag :span, book.author, :rel => "author")
      end
    end
  end

  def cover_sizes
    {
      "S" => 1,
      "M" => 2,
      "L" => 3
    }
  end
end

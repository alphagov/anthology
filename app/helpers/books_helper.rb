# typed: true
module BooksHelper
  def book_cover_tag(book, options = {})
    size = options[:size] || "S"
    zoom = cover_sizes[size]

    if book.google_id
      image_tag "https://books.google.co.uk/books?id=#{book.google_id}&printsec=frontcover&img=1&zoom=#{zoom}&edge=none&source=gbs_api", alt: "#{book.title} by #{book.author}", title: "#{book.title} by #{book.author}"
    else
      content_tag :div, class: "placeholder_book" do
        concat(book.title)
        concat(content_tag(:span, book.author, rel: "author"))
      end
    end
  end

  def cover_urls(book, size = "S")
    response = {}

    response[:google] = "https://books.google.co.uk/books?id=#{book[:google_id]}&printsec=frontcover&img=1&zoom=#{cover_sizes[size]}&edge=none&source=gbs_api" if book[:google_id]
    response[:openlibrary] = "https://covers.openlibrary.org/b/olid/#{book[:openlibrary_id]}-M.jpg" if book[:openlibrary_id]

    response
  end

  def cover_sizes
    {
      "S" => 1,
      "M" => 2,
      "L" => 3,
    }
  end

  def formatted_version_author(version)
    user_id = version.whodunnit
    if user_id.blank?
      "Unknown user"
    else
      T.must(User.where(id: user_id).first).name || "Unknown user"
    end
  end

  def formatted_version_changes(version)
    version.changeset.map do |key, (_old_value, new_value)|
      content_tag :li do
        (key.capitalize + ": " + content_tag(:code) { new_value.to_s }).html_safe
      end
    end.join("").html_safe # rubocop:disable Style/MethodCalledOnDoEndBlock
  end

  def user_or_second_person(resource_user, signed_in_user)
    return "unknown" if resource_user.blank?

    resource_user == signed_in_user ? "you" : resource_user.name
  end
end

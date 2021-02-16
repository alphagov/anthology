module BooksHelper
  def book_cover_tag(book, options = {})
    size = options[:size] || "S"
    zoom = cover_sizes[size]

    if book.google_id.present?
      image_tag "https://books.google.co.uk/books?id=#{book.google_id}&printsec=frontcover&img=1&zoom=#{zoom}&edge=none&source=gbs_api", alt: "#{book.title} by #{book.author}", title: "#{book.title} by #{book.author}"
    else
      tag.div class: "placeholder_book" do
        concat(book.title)
        concat(tag.span(book.author, rel: "author"))
      end
    end
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
      User.where(id: user_id).first.name || "Unknown user"
    end
  end

  def formatted_version_changes(version)
    version.changeset.map { |key, (_old_value, new_value)|
      tag.li do
        (key.capitalize + ": " + tag.code { new_value.to_s }).html_safe
      end
    }.join("").html_safe
  end

  def user_or_second_person(resource_user, signed_in_user)
    return "unknown" if resource_user.blank?

    resource_user == signed_in_user ? "you" : resource_user.name
  end
end

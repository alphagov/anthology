class BookMetadataLookup
  class BookNotFound < RuntimeError; end

  def self.find_by_isbn(isbn)
    format_response({
      google: GoogleBooks.search("isbn:#{isbn}", {}, ENV["REQUEST_IP"]).first,
      openlibrary: Openlibrary::Data.find_by_isbn(isbn: isbn),
    })
  end

  def self.format_response(sources)
    metadata = {}

    if sources[:google]
      metadata[:google_id] = sources[:google].id
      metadata[:title] ||= sources[:google].title
      metadata[:author] ||= sources[:google].authors
    end

    if sources[:openlibrary]
      metadata[:openlibrary_id] = sources[:openlibrary].identifiers["openlibrary"].first
      metadata[:title] ||= sources[:openlibrary].title
      metadata[:author] ||= sources[:openlibrary].authors
    end

    if metadata.empty?
      raise BookNotFound, sources.inspect
    end

    { google_id: nil, openlibrary_id: nil }.merge(metadata)
  end
end

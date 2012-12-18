class BookMetadataLookup
  class BookNotFound < Exception; end
  class InvalidResponse < Exception; end

  def self.find_by_isbn(isbn)
    format_response({
      :google => GoogleBooks.search("isbn:#{isbn}", { }, ENV['REQUEST_IP']).first,
      :openlibrary => Openlibrary::Data.find_by_isbn(isbn)
    })
  end

  private
    def self.json_request(uri)
      response = Net::HTTP.get URI.parse(uri)
      JSON.parse(response)
    end

    def self.format_response(sources)
      metadata = { }

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

      metadata
    end
end

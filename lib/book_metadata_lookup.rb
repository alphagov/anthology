class BookMetadataLookup
  class BookNotFound < Exception; end
  class InvalidResponse < Exception; end

  def self.find_by_isbn(isbn)
    format_response( GoogleBooks.search("isbn:#{isbn}", { }, ENV['REQUEST_IP']).first )
  end

  private
    def self.json_request(uri)
      response = Net::HTTP.get URI.parse(uri)
      JSON.parse(response)
    end

    def self.format_response(book)
      if book
        {
          :title => book.title,
          :author => book.authors,
          :google_id => book.id
        }
      elsif book.nil?
        raise BookNotFound, book.inspect
      else
        raise InvalidResponse, book.inspect
      end
    end
end

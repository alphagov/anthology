require "test_helper"
require "ostruct"
require "book_metadata_lookup"

class BookMetadataLookupTest < ActiveSupport::TestCase
  setup do
    @google_data = OpenStruct.new({
      id: "1",
      title: "Code Complete",
      authors: "Steve McConnell",
    })
    @openlibrary_data = OpenStruct.new({
      identifiers: { "isbn_13" => ["9781491914915"], "openlibrary" => ["OL27310496M"] },
      title: "Learning Javascript",
      authors: [{ "url" => "http://openlibrary.org/authors/OL1434387A/Ethan_Brown", "name" => "Ethan Brown" }],
    })
  end

  context ".find_by_isbn" do
    should "call both APIs with the given ISBN number" do
      isbn = "0995739013"

      GoogleBooks.expects(:search).with("isbn:#{isbn}").returns([@google_data])
      Openlibrary::Data.expects(:find_by_isbn).with(isbn).returns(@openlibrary_data)

      BookMetadataLookup.find_by_isbn(isbn)
    end
  end

  context ".format_response" do
    should "raise BookNotFound if sources does not contain google or openlibrary keys" do
      sources = { "another library" => "book" }

      assert_raises BookMetadataLookup::BookNotFound do
        BookMetadataLookup.format_response(sources)
      end
    end

    should "return book data when only google data is present" do
      sources = { google: @google_data, openlibrary: nil }

      expected_result = { google_id: "1", title: "Code Complete", author: "Steve McConnell", openlibrary_id: nil }

      assert_equal expected_result, BookMetadataLookup.format_response(sources)
    end

    should "return book data when only openlibrary data is present" do
      sources = { google: nil, openlibrary: @openlibrary_data }

      expected_result = {
        google_id: nil,
        openlibrary_id: "OL27310496M",
        title: "Learning Javascript",
        author: [{ "url" => "http://openlibrary.org/authors/OL1434387A/Ethan_Brown", "name" => "Ethan Brown" }],
      }

      assert_equal expected_result, BookMetadataLookup.format_response(sources)
    end

    should "use the title and author from google when both data sources are present" do
      sources = { google: @google_data, openlibrary: @openlibrary_data }

      expected_result = {
        google_id: "1",
        openlibrary_id: "OL27310496M",
        title: "Code Complete",
        author: "Steve McConnell",
      }

      assert_equal expected_result, BookMetadataLookup.format_response(sources)
    end
  end
end

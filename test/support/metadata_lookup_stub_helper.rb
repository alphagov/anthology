module MetadataLookupStubHelper
  def stub_metadata_lookup
    # stub the metadata lookup class in tests
    Book.metadata_lookup = MockBookMetadataLookup.new
  end
end

class MockBookMetadataLookup
  attr_accessor :response

  def find_by_isbn(isbn)
    response
  end
end

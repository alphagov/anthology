class MockBookMetadataLookup
  attr_accessor :response

  def find_by_isbn(isbn)
    response
  end
end

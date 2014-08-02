require 'test_helper'

class BookTest < ActiveSupport::TestCase

  context "creating a book" do
    context "given a valid ISBN" do
      setup do
        @atts = { "isbn" => "1554810396" }
      end

      should "attempt to look up metadata" do
        Book.metadata_lookup.response = {
          :title => "Alice's Adventures in Wonderland",
          :author => "Lewis Carroll"
        }
        book = Book.create!(@atts)

        assert_equal "Alice's Adventures in Wonderland", book.title
        assert_equal "Lewis Carroll", book.author
      end

      should "use save fields as nil if not present in model or metadata" do
        Book.metadata_lookup.response = { :author => "Lewis Carroll" }

        book = Book.create!(@atts)

        assert_equal nil, book.title
        assert_equal "Lewis Carroll", book.author
      end

      should "fall back to existing fields in the model if not present in metadata" do
        Book.metadata_lookup.response = { :author => "Lewis Carroll" }

        book = Book.create!(@atts.merge(
          :title => "Where Did He Go?",
          :author => "Otto Sight"
        ))

        assert_equal "Where Did He Go?", book.title
        assert_equal "Lewis Carroll", book.author
      end

      should "strip whitespace and dashes from the isbn" do
        book = Book.create!(:isbn => "0 1408-177-43")
        book.reload

        assert_equal "0140817743", book.isbn
      end
    end

    should "reject a blank ISBN" do
      book = Book.new(:isbn => '')

      assert ! book.valid?
    end

    should "create an initial copy upon creation" do
      book = FactoryGirl.create(:book)

      assert_equal 1, book.copies.count
    end

    should "set the creating user" do
      user = FactoryGirl.create(:user)
      book = FactoryGirl.create(:book, :created_by => user)

      assert_equal user.id, book.created_by.id
    end
  end

  context "editing a book" do
    context "changing the ISBN" do
      setup do
        @book = FactoryGirl.create(:book)
      end

      should "not lookup metadata again" do
        @book.expects(:update_metadata).never

        assert @book.update_attributes(:isbn => "0140817743")
      end

      should "persist the new isbn" do
        @book.update_attributes(:isbn => "0140817743")
        @book.reload

        assert_equal "0140817743", @book.isbn
      end

      should "strip whitespace and dashes from the isbn" do
        @book.update_attributes(:isbn => "0 1408-177-43")
        @book.reload

        assert_equal "0140817743", @book.isbn
      end
    end
  end

end

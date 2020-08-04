desc "Permanently deletes a book (and all of its copies) from the library"

task :delete_book, [:id] => :environment do |_task, args|
  book_id = args.id
  unless book_id
    puts "This task needs a book_id: rake delete_book[1] "
    exit
  end

  Book.find(book_id).destroy!
  puts "Deleted book #{book_id}"
end

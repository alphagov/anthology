desc "Update shelf numbers"

task :update_shelf_numbers_for_wcb => :environment do
  puts "Updating #{Shelf.count} shelves..."
  puts "Renamed 6th Floor to 7th Floor..."
  Shelf.last.update_attributes(name: "7th floor")
  puts "Renamed 3rd Floor to 6th Floor..."
  Shelf.first.update_attributes(name: "6th floor")
end

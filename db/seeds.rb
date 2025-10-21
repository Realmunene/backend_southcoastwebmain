# db/seeds.rb

require 'countries'

# ---- Seed Nationalities (all countries in the world) ----
puts "🌍 Seeding nationalities..."
Nationality.destroy_all

ISO3166::Country.all
  .sort_by { |c| c.translations['en'] || c.name }
  .each do |c|
    country_name = c.translations['en'] || c.name
    Nationality.find_or_create_by!(name: country_name)
  end

puts "✅ Seeded #{Nationality.count} nationalities."

# ---- Seed Room Types (with prices) ----
puts "🏨 Seeding room types..."
room_options = [
  { name: "Executive Room, Ensuite", price: 75 },
  { name: "2-Connected Room, 1 Ensuite", price: 110 },
  { name: "2 BedRoom Apartment-Live-1, Ensuite", price: 110 },
  { name: "2 BedRoom Apartment-Kitchen, 2 Ensuite", price: 125 },
  { name: "ExecutiveRoom, Ensuite", price: 75 },
  { name: "2-Connected Room, I-Ensuite", price: 110 },
  { name: "2 BedRoom Apartment with Kitchen, 1-Ensuite", price: 125 },
  { name: "Larger Apartment with Kitchen, Balcony, Living, 2 Ensuites", price: 140 }
]

# Clear existing room types before seeding
RoomType.destroy_all

# Remove duplicates and seed
room_options.uniq { |r| r[:name] }.each do |room|
  RoomType.find_or_create_by!(name: room[:name]) do |rt|
    rt.price = room[:price]
  end
end

puts "✅ Seeded #{RoomType.count} unique room types with prices."

# ---- Seed Admin Accounts ----
puts "👑 Seeding admin users..."

# Main admin account (existing)
puts "Seeding admin users..."

# Main admin account
Admin.find_or_create_by!(email: "southcoastoutdoors25@gmail.com") do |admin|
  admin.password = "Admin@123"
  admin.password_confirmation = "Admin@123"
  admin.role = :admin
  admin.name = "Super Admin"
end

# Backup/system admin if no other admin exists
if Admin.count == 1
  Admin.find_or_create_by!(email: 'admin@example.com') do |admin|
    admin.password = 'Admin123!'
    admin.password_confirmation = 'Admin123!'
    admin.name = 'System Administrator'
    admin.role = :admin
  end
  puts "✅ Backup Admin user created: admin@example.com / Admin123!"
end

puts "✅ Total Admin Users: #{Admin.count}"
puts "🎉 Seeding complete!"

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

RoomType.destroy_all
room_options.uniq { |r| r[:name] }.each do |room|
  RoomType.find_or_create_by!(name: room[:name]) do |rt|
    rt.price = room[:price]
  end
end

puts "✅ Seeded #{RoomType.count} unique room types with prices."

# ---- Seed Admin Accounts ----
puts "👑 Seeding admin users..."

# Ensure only one Super Admin exists
super_admin_email = "southcoastoutdoors25@gmail.com"
super_admin = Admin.find_by(role: 0) # ✅ Use integer for enum: 0 = super_admin

if super_admin.nil?
  Admin.create!(
    email: super_admin_email,
    password: "Admin@123",
    password_confirmation: "Admin@123",
    role: 0,           # ✅ integer value
    name: "Super Admin"
  )
  puts "✅ Super Admin created: #{super_admin_email}"
else
  puts "ℹ️ Super Admin already exists (#{super_admin.email}). Skipping creation."
end

# Optional: Create a backup admin if only the super_admin exists
if Admin.count == 1
  Admin.find_or_create_by!(email: "admin@example.com") do |admin|
    admin.password = "Admin123!"
    admin.password_confirmation = "Admin123!"
    admin.name = "System Administrator"
    admin.role = 1     # ✅ integer value for admin
  end
  puts "✅ Backup Admin user created: admin@example.com / Admin123!"
else
  puts "ℹ️ Additional admin(s) already exist. No backup admin created."
end

puts "✅ Total Admin Users: #{Admin.count}"
puts "🎉 Seeding complete!"

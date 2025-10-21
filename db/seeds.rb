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

# Define roles as integers
SUPER_ADMIN = 0
ADMIN = 1

super_admin_email = "southcoastoutdoors25@gmail.com"

# For Render: Clear any conflicting super admins first
conflicting_admins = Admin.where(role: SUPER_ADMIN)
if conflicting_admins.any?
  puts "🔄 Removing #{conflicting_admins.count} conflicting super admin records..."
  conflicting_admins.destroy_all
end

# Create super admin
begin
  Admin.create!(
    email: super_admin_email,
    password: "Admin@123",
    password_confirmation: "Admin@123",
    role: SUPER_ADMIN,
    name: "Super Admin"
  )
  puts "✅ Super Admin created: #{super_admin_email}"
rescue => e
  puts "⚠️ Super Admin creation issue: #{e.message}"
  # Try alternative approach if creation fails
  admin = Admin.find_or_initialize_by(email: super_admin_email)
  admin.attributes = {
    password: "Admin@123",
    password_confirmation: "Admin@123",
    role: SUPER_ADMIN,
    name: "Super Admin"
  }
  admin.save!
  puts "✅ Super Admin updated: #{super_admin_email}"
end

# Create backup admin only if no other admins exist (excluding the super admin)
if Admin.where(role: ADMIN).none?
  begin
    Admin.create!(
      email: "admin@example.com",
      password: "Admin123!",
      password_confirmation: "Admin123!",
      name: "System Administrator",
      role: ADMIN
    )
    puts "✅ Backup Admin user created: admin@example.com"
  rescue => e
    puts "⚠️ Backup admin creation issue: #{e.message}"
  end
else
  puts "ℹ️ Additional admin(s) already exist. No backup admin created."
end

puts "✅ Total Admin Users: #{Admin.count}"
puts "🎉 Seeding complete!"
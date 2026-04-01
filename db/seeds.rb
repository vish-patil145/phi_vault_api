puts "Seeding Users..."

users = [
  {
    email: "admin@hospital.com",
    password: "password123",
    role: :admin
  },
  {
    email: "doctor@hospital.com",
    password: "password123",
    role: :doctor
  },
  {
    email: "nurse@hospital.com",
    password: "password123",
    role: :nurse
  },
  {
    email: "lab@hospital.com",
    password: "password123",
    role: :lab_technician
  }
]

users.each do |user_data|
  user = User.find_or_initialize_by(email: user_data[:email])
  user.password = user_data[:password]
  user.role = user_data[:role]
  user.save!
end

puts "Users seeded successfully!"

# db/seeds.rb

puts "🌱 Seeding patients..."

patients = [
  { name: "Aarav Sharma",    age: 34, gender: "male" },
  { name: "Priya Patel",     age: 28, gender: "female" },
  { name: "Rohit Mehta",     age: 45, gender: "male" },
  { name: "Sneha Iyer",      age: 31, gender: "female" },
  { name: "Vikram Singh",    age: 52, gender: "male" },
  { name: "Ananya Gupta",    age: 24, gender: "female" },
  { name: "Manish Joshi",    age: 38, gender: "male" },
  { name: "Kavya Nair",      age: 29, gender: "female" },
  { name: "Arjun Reddy",     age: 41, gender: "male" },
  { name: "Deepika Verma",   age: 36, gender: "female" }
]

patients.each do |attrs|
  Patient.find_or_create_by!(name: attrs[:name]) do |p|
    p.age    = attrs[:age]
    p.gender = attrs[:gender]
  end
end

puts "✅ #{Patient.count} patients seeded"

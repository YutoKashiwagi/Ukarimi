User.create!(
  name: "hogehoge",
  email: "hogehoge@hogehoge.com",
  password: "hogehoge"
)

10.times do |n|
  name = "sample"
  email = "email-#{n + 1}@email.com"
  password = "password"
  User.create!(
    name: name,
    email: email,
    password: password
  )
end

# Question
10.times do 
  user = User.first
  Question.create!(
    user_id: user.id,
    title: "question title",
    content: "question content"
  )
end
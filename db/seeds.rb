require 'faker'

Faker::Config.locale = :ja

# Category
subjects = %w[現代文 漢文 古文 世界史 日本史 地理 現代社会 倫理 政治 経済 数学I・A 数学II・B 数学III 物理 化学 生物 地学 英語]
subjects.each do |subject|
  Category.create(
    name: subject
    )
end

guest = User.create(
  name: 'ゲスト',
  email: 'guest@guest.com',
  password: 'password',
  role: :guest
)

hoge = User.create(
  name: "hogehoge",
  email: "hogehoge@hogehoge.com",
  password: "hogehoge"
)
      
tanaka = User.create(
  name: '田中太郎',
  email: 'tanaka@tanaka.com',
  password: 'password'
)

Category.all.each do |category|
  question = guest.questions.create(
    title: "#{category.name}のオススメ参考書",
    content: "現在高校一年生です。大学に進学したいので、#{category.name}のオススメ参考書を教えてください！＞＜",
    created_at: 1.days.ago
  )
  question.categories << category
  post = guest.posts.create(
    content: "今日は#{category.name}の勉強を頑張った！明日も頑張ろう！"
  )
  post.categories << category
end

math1 = Category.find_by(name: '数学I・A')
math2 = Category.find_by(name: '数学II・B')
math3 = Category.find_by(name: '数学III')
math = [math1, math2, math3]
        
question1 = Question.create(
  user_id: tanaka.id,
  title: '数学のオススメ参考書',
  content: '現在高校一年生です。理系の大学に進学したいので、オススメの参考書を教えてください',
  categories: math
)
          
answer1 = question1.answers.create(
  user_id: guest.id,
  content: '基礎問題精講シリーズがオススメです'
)

question1.decide_best_answer(answer1)

answer1.comments.create(
  user: tanaka,
  content: '回答ありがとうございます！'
)

10.times do |n|
  name = Faker::Name.name
  email = "email-#{n + 1}@email.com"
  password = "password"
  User.create!(
    name: name,
    email: email,
    password: password
  )
end

users = User.all
users.each do |user|
  user.follow(guest)
end

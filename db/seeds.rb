User.create(email_address: "foo@bar", password: "foo@bar")
User.create(email_address: "bar@foo", password: "bar@foo")
1000.times do
  Comment.create(author: Faker::Book.author, content: Faker::Lorem.sentence, user: User.first)
  Comment.create(author: Faker::Book.author, content: Faker::Lorem.sentence, user: User.last)
end

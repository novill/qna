require 'to_words'
require 'betterlorem'
10.times do |i|
  password = (10**6 +rand(10**6)).to_s
  User.create_with(password: password, password_confirmation: password).find_or_create_by(email: "2alexeysh+test#{i}@gmail.com")
end

20.times do |i|
  title = "Sample question #{i.to_words}"
  body = BetterLorem.w(30, true)
  question = Question.create_with(body: body, user: User.all.sample).find_or_create_by(title: title)
  question.subscriptions.delete_all
end


Question.first.links.
  create_with(url:'https://gist.github.com/novill/ca4a01934576cc036c49b2faa2900f3c').
  find_or_create_by(name: 'Sample gist link')

Question.first.links.create_with(url:'https://thinknetica.teachbase.ru/course_sessions/93683/tasks/47789/take?return_url=/viewer/sessions/93683/tasks/47789').
  find_or_create_by(name: 'Sample external link')

200.times do |i|
  body = "Sample answer #{i.to_words}"
  Answer.create_with(question: Question.all.sample, user: User.all.sample).find_or_create_by(body: body)
end

puts "Questions: #{Question.all.count} Answers: #{Answer.all.count} Links: #{Link.all.count} Subscriptions: #{Subscription.all.count}"


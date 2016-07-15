# Create main user
=begin

user = User.create!(
  name: 'Fabio',
  email: 'fabio@example.com',
  password: 'secret!'
)

20.times do
  title = Faker::Book.title
  artist = Faker::Commerce.product_name
  slug = Faker::Internet.slug("#{artist} #{title}")
  user.tunes.create!(
    title: title,
    artist: artist,
    url: Faker::Internet.url('example.com', "/#{slug}"),
    comments: Faker::Hipster.sentences.join(' ')
  )
end

=end


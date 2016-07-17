class DrakeTip < ActiveRecord::Base

  belongs_to :user
  belongs_to :lyric

  validates :user_id, :lyric_id,
    presence: { message: "Foreign keys required" }


  def determine_keywords(user_question)
    case
    when user_question.match(/what/i)
      "what"
    when user_question.match(/where/i)
      "where"
    when user_question.match(/when/i)
      "when"
    when user_question.match(/who/i)
      "who"
    when user_question.match(/why/i)
      "why"
    when user_question.match(/do\syou/i)
      "do you"
    else
      special_questions ? special_questions : "non-question"
    end
  end

  def special_questions
    #conditions for special questions; if found one, return id of special answer, else return nil
  end

  # Determine advice
  def get_lyric(keyword)
    lyrics = Lyric.where(category: keyword).all
    puts "lyrics: #{lyrics}, keyword: #{keyword}"
    chosen_lyric = lyrics[rand(0..(lyrics.length.to_i - 1))] # Return a random row out of the set of matching lyrics
    chosen_lyric
  end

  # Turn into image
  def image_render(lyric)

    # 1. Read background image (#read returns an array, so gets the .first item in it)
    background = Magick::Image.read('./app/assets/background.png').first

    # 2. Create a new text
    caption = Magick::Image.read("caption:#{lyric}") {
      self.size = "450x450"
      self.font = "./app/assets/fonts/HelveticaNeue-MediumItalic.ttf" #See for custom fonts: http://stackoverflow.com/questions/28043993/rmagick-unable-to-read-font and http://www.simplesystems.org/RMagick/doc/draw.html
      #self.font = "HelveticaNeue-BoldItalic" #See for custom fonts: http://stackoverflow.com/questions/28043993/rmagick-unable-to-read-font and http://www.simplesystems.org/RMagick/doc/draw.html
      #self.gravity = NorthWestGravity # Not working, parking for now
      self.pointsize = 30
      self.background_color = "none"
      self.fill = "white"
      # self.stroke = "white"
      # self.stroke_width = 2
      #self.page = Rectangle.new(450, 450, 100, 100)
    }.first

    # 3. Merge and position caption over background - see http://rmagick.rubyforge.org/src_over.html
    merged = background.composite(caption, 25, 25, Magick::OverCompositeOp)

    merged.write("./draketip_#{id}.png")
    #a.write("./draketip_#{id}.png")

  end

end

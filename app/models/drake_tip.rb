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
    when user_question.match(/should/i)
      "should"
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
    background = Magick::Image.read("./app/assets/background_#{rand(1..4)}.png").first

    # 2. Create a new text
    advice = Magick::Image.read("caption:#{lyric}") {
      self.size = "450x450"
      self.font = "./app/assets/fonts/HelveticaNeue-BoldItalic.ttf" #See for custom fonts: http://stackoverflow.com/questions/28043993/rmagick-unable-to-read-font and http://www.simplesystems.org/RMagick/doc/draw.html
      #self.gravity = NorthWestGravity # Not working, parking for now
      self.pointsize = 35
      self.background_color = "none"
      self.fill = "white"
      # self.stroke = "white"
      # self.stroke_width = 2
    }.first

    counter = Magick::Image.read("caption:647.722.DRIZ / HOTLINE PING NO.#{100000+id.to_i} / MADE IN THE 6 BY A FAN, NOT THE REAL DRAKE") {
      self.size = "450x30"
      self.font = "./app/assets/fonts/HelveticaNeue-MediumItalic.ttf" #See for custom fonts: http://stackoverflow.com/questions/28043993/rmagick-unable-to-read-font and http://www.simplesystems.org/RMagick/doc/draw.html
      #self.gravity = NorthWestGravity # Not working, parking for now
      self.pointsize = 10
      self.background_color = "none"
      self.fill = "white"
      # self.stroke = "white"
      # self.stroke_width = 2
    }.first

    # 3. Merge and position caption over background - see http://rmagick.rubyforge.org/src_over.html
    merged_step1 = background.composite(advice, 25, 25, Magick::OverCompositeOp)
    merged_step2 = merged_step1.composite(counter, 25, 475, Magick::OverCompositeOp)
    merged_step2.write("./public/draketips/draketip_#{self.user_id}_#{self.lyric_id}.png")

  end

end

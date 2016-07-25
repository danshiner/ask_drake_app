class DrakeTip < ActiveRecord::Base

  belongs_to :user
  belongs_to :lyric

  # validates :user_id, :lyric_id,
  #   presence: { message: "Foreign keys required" }

  def determine_keywords(user_question)

    case
    # Special situations
    when user_question.match(/toronto/i) || user_question.match(/the\s6/i) || user_question.match(/the\s6/i) || user_question.match(/the\ssix/i)
      "toronto"
    when user_question.match(/food/i) || user_question.match(/eat/i) || user_question.match(/breakfast/i) || user_question.match(/lunch/i) || user_question.match(/dinner/i)
      "food"
    when user_question.match(/girl/i) || user_question.match(/love/i) || user_question.match(/woman/i)
      "love"
    when user_question.match(/money/i)
      "money"
    when user_question.match(/vishal/i)
      "vishal"
    when user_question.match(/pokemon/i)
      "pokemon"
    when user_question.match(/what's\sup/i) || user_question.match(/what's\sgoing\son/i) || user_question.match(/whats\ares\you/i)
      "vishal"
    when user_question.match(/hows\ares\you/i) || user_question.match(/hows\ares\u/i) || user_question.match(/hows\rs\u/i)
      "how are you"
    # Main question words
    when user_question.match(/what/i)
      "what"
    when user_question.match(/what\sis/i)
      "what is"
    when user_question.match(/what\swas/i)
      "what was"
    when user_question.match(/what\swill/i)
      "what will"
    when user_question.match(/what\sshould/i)
      "what should"
    when user_question.match(/where/i)
      "where"
    when user_question.match(/when/i)
      "when"
    when user_question.match(/who/i)
      "who"
    when user_question.match(/why/i)
      "why"
    when user_question.match(/^should/i)
      "should"
    when user_question.match(/will/i)
      "will"
    when user_question.match(/how/i)
      "how"
    else
      "non-question"
    end
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
    counter = Magick::Image.read("caption:647.722.DRIZ / HOTLINE PING NO.#{100000+self.id} / MADE IN THE 6 BY A FAN, NOT THE REAL DRAKE") {
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
    merged_step2.write("./public/draketips/draketip_#{100000+self.id}.png")

  end

  # def remove_credit_from_user
  #   self.user.credits -= 1
  #   self.user.save!
  # end

end

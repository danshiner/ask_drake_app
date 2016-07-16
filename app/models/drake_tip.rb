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
    chosen_lyric = lyrics[rand(0..(lyrics.length - 1))] # Return a random row out of the set of matching lyrics
    chosen_lyric
  end

  # Turn into image
  def image_render(lyric)

    # Turn into image
    def image_render(lyric)
      # 1. Read background image
      img = Magick::Image::read("./app/assets/background.png")[0]
      binding.pry
      # 2. Create a new text

      caption = Magick::Image.read("caption:#{lyric}") {
        self.size = "200x300"
        self.font = "Tahoma" #See for custom fonts: http://stackoverflow.com/questions/28043993/rmagick-unable-to-read-font
        # self.gravity = NorthWestGravity # Not working, parking for now
        self.pointsize = 30
      }[0]

      # 3. Save new file
      caption.write("./draketip_#{id}.png")
      # puts "I am running, my friend!"
      # puts Dir.pwd

    end


    # 1. Read background image

    # img = Magick::ImageList::read("./app/assets/background.png")
    #
    # # 2. Create a new text
    # img << Magick::Image.read("caption:#{lyric}") {
    #   self.size = "200x300"
    #   self.font = "Tahoma" #See for custom fonts: http://stackoverflow.com/questions/28043993/rmagick-unable-to-read-font
    #   # self.gravity = NorthWestGravity # Not working, parking for now
    #   self.pointsize = 30
    # }[0]
    #
    # # 3. Save new file
    #
    # #img << caption
    # a = img.flatten_images
    #
    # a.write("./draketip_#{id}.png")

  end

end

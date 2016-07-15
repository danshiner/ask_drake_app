class DrakeTip < ActiveRecord::Base

  belongs_to :user
  belongs_to :lyric

  validates :user_id, :lyric_id, 
    presence: { message: "Foreign keys required" }

  def advise
  
    keyword = determine_keywords(body) #NEED TO GET BODY AS PARAM IN INITIALIZE
    lyric = lookup(keyword)
    image = image_render(lyric)

    return image

    # YOU ARE HERE! Key stuff is defined. Now have to figure out how to test and implement: populating/seeding, putting online 

  end 

  def determine_keywords(body)
    case
    when body.match(/what/i)
      "what"
    when body.match(/where/i)
      "where"
    when body.match(/when/i)
      "when"
    when body.match(/who/i)
      "who"
    when body.match(/why/i)
      "why"
    when body.match(/do\syou/i)
      "do you"
    else
      special_questions ? special_questions : "non-question"
    end
  end

  def special_questions
    #conditions for special questions; if found one, return id of special answer, else return nil  
  end

  # Determine advice
  def lookup(keyword)
    lyrics = Lyric.where(category: keyword).all
    lyrics[rand(0..(lyrics.length - 1))] # Return a random row of the matching lyrics   
  end

  # Turn into image
  def image_render(lyric)
    
    # 1. Read background image
    img = Magick::Image::read("../assets/background.png")[0] 

    # 2. Create a new text

    caption = Magick::Image.read("caption:#{lyric}") {
      self.size = "200x300"
      self.font = "Tahoma" #See for custom fonts: http://stackoverflow.com/questions/28043993/rmagick-unable-to-read-font
      # self.gravity = NorthWestGravity # Not working, parking for now
      self.pointsize = 30
    }[0]

    # 3. Save new file
    caption.write("draketip_#{id}.png")
    
  end

end





    
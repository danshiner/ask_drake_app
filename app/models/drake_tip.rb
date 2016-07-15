#FOR TESTING
require 'rubygems'
require 'bundler/setup'
require 'active_support/all'
require 'sinatra/activerecord'

class DrakeTip < ActiveRecord::Base

  belongs_to :user
  belongs_to :lyric

  validates :user_id, :lyric_id, 
    presence: { message: "Foreign keys required" }

  def determine_keywords(body)
    words = body.split(" ")
    case words
    when words.include?("What" || "what")
      "what"
    when words.include?("Where" || "where")
      "where"
    when words.include?("When" || "when")
      "when"
    when words.include?("Who" || "who")
      "who"
    when words.include?("Why" || "why")
      "why"
    when words.include?("Do you" || "do you")
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
    lyrics[Random.new.rand(1..(lyrics.length - 1))] # Return a random row of the matching lyrics   
  end

  # Turn into image
  def render
  end

end





    
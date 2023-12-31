class Review < ApplicationRecord
  before_save :calculate_average_rating
  belongs_to :user
  belongs_to :book

  def calculate_average_rating
    self.average_rating = ((self.content_rating.to_f + self.recommend_rating.to_f) / 2).round(2)
  end

  def self.allowed_attributes
    [:title, :content_rating, :recommend_rating]
  end
end

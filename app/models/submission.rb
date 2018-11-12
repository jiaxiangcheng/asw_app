class Submission < ApplicationRecord
    validates :title, presence: true
    validate :check_not_both
    validate :correct_url_format
    validates :user, :presence => true
    
    acts_as_votable

    belongs_to :user
    has_many :comments
    has_many :replies, as: :parent, class_name: "Comment", inverse_of: :parent, dependent: :destroy
    private
    def correct_url_format
        unless url.blank?
            unless url =~ /(https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|www\.[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9]\.[^\s]{2,}|www\.[a-zA-Z0-9]\.[^\s]{2,})/
                errors.add(:base, "Invalid URL format, please try again!")
            end
        end
    end
    def check_not_both
        unless text.blank? ^ url.blank?
        errors.add(:base, "Specify a text or a url, not both!")
        end
    end


end

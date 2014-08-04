class User < ActiveRecord::Base
  has_many :loans, :dependent => :destroy
  has_many :copies, -> { where('loans.state' => 'on_loan') }, through: :loans
  has_many :books, :through => :copies

  validates :provider_uid, :presence => true, :uniqueness => true

  def current_copies
    copies.includes(:book)
  end

  def previous_loans
    loans.returned.includes(:copy).includes(:book)
  end

  def self.find_or_create_from_auth_hash(auth_hash)
    existing_user = self.where(email: auth_hash[:info][:email]).first
    atts = {
      name: auth_hash[:info][:name],
      image_url: auth_hash[:info][:image],
      provider:  auth_hash[:provider],
      provider_uid: auth_hash[:uid],
    }

    if existing_user.present?
      existing_user.update_attributes(atts)
      existing_user
    else
      self.create!(atts.merge(
        email: auth_hash[:info][:email]
      ))
    end
  end
end

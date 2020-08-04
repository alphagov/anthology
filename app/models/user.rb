class User < ApplicationRecord
  has_many :loans, dependent: :destroy
  has_many :copies, -> { where("loans.state" => "on_loan") }, through: :loans
  has_many :books, through: :copies

  validates :provider_uid, presence: true, uniqueness: true
  validate :email_has_permitted_hostname, on: :create

  class CreationFailure < StandardError; end

  def current_copies
    copies.includes(:book)
  end

  def previous_loans
    loans.returned.includes(:copy).includes(:book)
  end

  def self.find_or_create_from_auth_hash!(auth_hash)
    existing_user = find_by(email: auth_hash[:info][:email])

    if existing_user.present?
      existing_user.update!(atts_from_auth_hash(auth_hash))
      existing_user
    else
      user = new(initial_atts_from_auth_hash(auth_hash))

      if user.save
        user
      else
        raise CreationFailure, user.errors.full_messages.join(", ")
      end
    end
  end

  def self.atts_from_auth_hash(hash)
    {
      name: hash[:info][:name],
      image_url: hash[:info][:image],
      provider: hash[:provider],
      provider_uid: hash[:uid],
    }
  end

  def self.initial_atts_from_auth_hash(hash)
    atts_from_auth_hash(hash).merge(
      email: hash[:info][:email],
    )
  end

  def email_has_permitted_hostname
    if email.blank? || Books.permitted_email_hostnames.empty?
      return
    end

    hostname = email.match(/@([A-Za-z0-9\-\.]+)\Z/) do |matches|
      matches[1]
    end

    unless Books.permitted_email_hostnames.include?(hostname)
      errors.add(:email, "must be on a permitted hostname")
    end
  end
end

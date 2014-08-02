class User < ActiveRecord::Base
  has_many :loans, :dependent => :destroy
  has_many :copies, -> { where('loans.state' => 'on_loan') }, through: :loans
  has_many :books, :through => :copies

  validates :github_id, :presence => true, :uniqueness => true

  def current_copies
    copies.includes(:book)
  end

  def previous_loans
    loans.returned.includes(:copy).includes(:book)
  end

  def self.find_or_create_from_auth_hash(auth_hash)
    github_id = auth_hash.uid.to_s
    nickname = auth_hash.info ? auth_hash.info.nickname : nil

    current_user = self.where(:github_id => github_id).first
    if current_user
      current_user.update_attributes(
        :name => auth_hash.info.name,
        :github_login => nickname,
      )
    else
      current_user = self.create!(:github_id => github_id, :name => auth_hash.info.name, :github_login => nickname
        )
    end

    current_user
  end
end

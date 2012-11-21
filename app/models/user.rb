class User < ActiveRecord::Base
  attr_accessible :name, :github_id

  has_many :loans, :dependent => :destroy
  has_many :copies, :through => :loans, :conditions => ['loans.state = ?','on_loan']
  has_many :books, :through => :copies

  def current_copies
    copies.includes(:book)
  end

  def previous_loans
    loans.returned.includes(:copy).includes(:book)
  end

  def self.find_or_create_from_auth_hash(auth_hash)
    github_id = auth_hash.uid.to_s

    current_user = self.where(:github_id => github_id).first
    if current_user
      current_user.update_attributes(
        :name => auth_hash.info.name
      )
    else
      current_user = self.create!(:github_id => github_id, :name => auth_hash.info.name)
    end

    current_user
  end
end

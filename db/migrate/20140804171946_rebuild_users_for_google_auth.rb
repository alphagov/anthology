# frozen_string_literal: true

class RebuildUsersForGoogleAuth < ActiveRecord::Migration[5.2]
  class User < ActiveRecord::Base
  end

  def change
    change_table :users do |t|
      t.remove :github_id, :github_login

      t.string :email
      t.string :provider
      t.string :provider_uid
      t.string :image_url
    end
  end
end

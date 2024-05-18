# db/migrate/20240516185044_add_user_id_to_articles.rb

class AddUserIdToArticles < ActiveRecord::Migration[6.0]
  def change
    add_reference :articles, :user, foreign_key: true, null: true
  end
end

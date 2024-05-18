class AddArchivedToArticles < ActiveRecord::Migration[7.1]
  def change
    add_column :articles, :archived, :boolean
  end
end

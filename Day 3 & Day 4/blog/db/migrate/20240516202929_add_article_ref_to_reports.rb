class AddArticleRefToReports < ActiveRecord::Migration[7.1]
  def change
    add_reference :reports, :article, null: false, foreign_key: true
  end
end

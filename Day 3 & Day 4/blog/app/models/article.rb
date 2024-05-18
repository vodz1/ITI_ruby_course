class Article < ApplicationRecord
    belongs_to :user
    has_many :comments, dependent: :destroy
    has_one_attached :image
    has_many :reports, class_name: 'Report'

    validates :title, presence: true
    validates :body, presence: true, length: { minimum: 10 }
  
    enum status: { draft: 0, published: 1, archived: 2 }
    attribute :article_status, :integer, default: 0
    scope :active, -> { where(archived: false) }

    # Callback to archive article if reports count is 3
    before_save :archive_article, if: -> { reports_count >= 3 }
    def reports_count
        # Logic to calculate reports count goes here
        # For example, you might query related models to count reports
        reports.count
      end
  
    private
  
    def archive_article
        self.archived = true
    end
  end
  
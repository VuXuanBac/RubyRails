class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image do |attachable|
    attachable.variant :display,
                       resize_to_limit: Settings.display_image_size_max
  end

  scope :newest, -> { order created_at: :desc }
  scope :for_users, ->(id) { where user_id: id }

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: Settings.validation.content_len_max }

  validates :image,
            content_type: {
              in: Settings.validation.image_type,
              message: I18n.t("errors.invalid_type", type: I18n.t("text.image")),
            },
            size: {
              less_than: Settings.validation.image_size_max.megabytes,
              message: I18n.t("errors.larger_size", size: Settings.validation.image_size_max),
            }
end

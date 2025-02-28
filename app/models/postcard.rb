class Postcard < ApplicationRecord
  belongs_to :photo
  belongs_to :recipient, optional: true

  has_one :user, through: :photo

  after_commit :send_with_lob_if_sendable

  enum status: %i[pending processing mailed in_transit delivered]

  validates :caption, length: {
    maximum: 200,
    too_long: '200 characters is the maximum allowed'
  }

  PRICE = 295

  self.per_page = 15

  def photo_url
    photo.ig_media_url
  end

  def month_year
    photo.ig_timestamp.strftime('%B %Y')
  end

  def lob_description
    "postcard_id_#{id}"
  end

  private

  def send_with_lob_if_sendable
    SendPostcardJob.perform_later(self) if sendable?
  end

  def sendable?
    recipient.present? &&
      photo.present? &&
      stripe_charge_id.present?
  end
end

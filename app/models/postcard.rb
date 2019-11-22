class Postcard < ApplicationRecord
  belongs_to :photo
  belongs_to :recipient, optional: true

  has_one :user, through: :photo

  after_commit :send_with_lob_if_sendable

  enum status: %i[in_transit in_local_area processed_for_delivery re_routed
                  returned_to_sender]

  PRICE = 295

  def lob_description
    "postcard_id_#{id}"
  end

  private

  def send_with_lob_if_sendable
    SendPostcardJob.perform_async(self) if sendable?
  end

  def sendable?
    recipient.present? &&
      photo.present? &&
      stripe_charge_id.present?
  end
end

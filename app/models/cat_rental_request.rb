# == Schema Information
#
# Table name: cat_rental_requests
#
#  id         :integer          not null, primary key
#  cat_id     :integer          not null
#  start_date :date             not null
#  end_date   :date             not null
#  status     :string           default("PENDING"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  e = CatRentalRequest.new(cat_id: 2, start_date: Date.new(2017,8,24), end_date: Date.new(2017,8,29) )
#

class CatRentalRequest < ApplicationRecord
  validates :cat_id, :start_date, :end_date, :status, presence: true
  validates :status, inclusion: { in: ['PENDING', 'APPROVED', 'DENIED'],
    message: '%{value}: wrong status'
  }
  validate :does_not_overlap_approved_request
  validate :valid_start_end

  belongs_to :cat, primary_key: :id, foreign_key: :cat_id, class_name: :Cat

  def valid_start_end
    start_date < end_date
  end

  def overlapping_requests
    overlap = CatRentalRequest.where(["cat_id = ? AND ((start_date between ? and ?) OR (end_date between ? and ?)) ",
    cat_id,
    start_date, end_date,
    start_date, end_date
    ])
  end

  def overlapping_approved_requests
    overlapping_requests.where("status = \'APPROVED\'")
  end

  def overlapping_pending_requests
    overlapping_requests.where("status = \'PENDING\'")
  end

  def does_not_overlap_approved_request
    overlapping_approved_requests.exists?
  end

  def approve!
    ActiveRecord::Base.transaction do
      self.status = "APPROVED"
      self.save
      overlapping_pending_requests.each do |request|
        request.deny!
      end
    end
  end

  def deny!
    self.status = "DENIED"
    self.save
  end
end

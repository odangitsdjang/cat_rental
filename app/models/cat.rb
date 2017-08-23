# == Schema Information
#
# Table name: cats
#
#  id          :integer          not null, primary key
#  birth_date  :date             not null
#  color       :string           not null
#  name        :string           not null
#  sex         :string(1)        not null
#  description :text             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Cat < ApplicationRecord

  COLORS = %w(blue red green orange yellow indigo violet purple
              turquoise white black )
  validates :birth_date, :color, :name, :sex, :description, presence: true

  validates :color, inclusion: { in: COLORS,
    message: "%{value} is not a valid color" }
  validates :sex, inclusion: { in: %w(m f M F),
      message: "%{value} is not a valid sex" }

  has_many :rentals, primary_key: :id, foreign_key: :cat_id,
    class_name: :CatRentalRequest, dependent: :destroy
  def age
    ((Date.today - birth_date)/365).to_i
  end

  def colors
    COLORS
  end
end

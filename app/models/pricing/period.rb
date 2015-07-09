class Pricing::Period < ActiveRecord::Base
  has_many :prices

  validates_presence_of :name
  validate :end_date_cannot_be_before_start_date

  private
  def end_date_cannot_be_before_start_date
    unless start_date.blank? || end_date.blank?
      errors.add(:end_date, 'can not be before the start date') if end_date < start_date
      errors.add(:end_date, 'can not be the same as the start date') if end_date == start_date
    end
  end
end

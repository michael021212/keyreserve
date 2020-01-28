class CharteredFacility < ApplicationRecord
  belongs_to :facility

  validate :child_facility_id_must_be_unique_by_facility

  def child_facility_id_must_be_unique_by_facility
    if facility.chartered_facilities.map{|f| f.child_facility_id }.count(child_facility_id) >= 2
      errors.add(:child_facility_id, 'はユニークにしてください')
    end
  end
end

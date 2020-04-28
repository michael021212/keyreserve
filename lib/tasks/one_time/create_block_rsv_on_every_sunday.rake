namespace :reservation do
  task :create_block_rsv_on_every_sunday => :environment do
    start_at = DateTime.new(2020, 5, 1, 0, 0, 0, '+09:00')
    finish_at = DateTime.new(2020, 7, 31, 0, 0, 0, '+09:00')
    facility = Facility.find_by(id: 92)
    facility_dropin_plan = FacilityDropinPlan.find_by(id: 23)
    facility_dropin_sub_plan = FacilityDropinSubPlan.find_by(id: 31)
    facility_key = FacilityKey.find_by(id: 117)
    user = User.find_by(id: 239)
    (start_at..finish_at).each do |d|
      next unless d.sunday?
      DropinReservation.create(
        facility_id: facility.id,
        facility_dropin_plan_id: facility_dropin_plan.id,
        facility_dropin_sub_plan_id: facility_dropin_sub_plan.id,
        facility_key_id: facility_key.id,
        user_id: user.id,
        reservation_user_id: user.id,
        checkin: d + 11.hours,
        checkout: d + 18.hours,
        price: 0,
        mail_send_flag: false,
        state: 1
      )
    end
  end
end

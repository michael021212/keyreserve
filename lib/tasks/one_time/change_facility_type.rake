namespace :facility do
  desc 'facility_typeがrent(3)とcar(4)とpublic_place(6)のもの=>conference_room(1)に統一、accommodation(8)のもの=>accommodation(3)に、ks_flexilbe(5)のもの=>ks_flexilbe(4)に、chartered_place(7)のもの=>chartered_place(5)にする'
  task change_facility_type: :environment do
    Facility.where(facility_type: [3, 4, 6]).each { |facility| facility.update_attribute(:facility_type, 1) }
    Facility.where(facility_type: 8).each { |facility| facility.update_attribute(:facility_type, 3) }
    Facility.where(facility_type: 5).each { |facility| facility.update_attribute(:facility_type, 4) }
    Facility.where(facility_type: 7).each { |facility| facility.update_attribute(:facility_type, 5) }
  end
end

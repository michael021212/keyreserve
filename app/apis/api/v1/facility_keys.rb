module API
  module V1
    class FacilityKeys < Grape::API
      resource :facility_keys do

        # 鍵更新
        params do
          requires :facility_id, type: Integer
          requires :ks_room_key_id, type: Integer
        end
        patch '/', jbuilder: 'facility_keys/update' do
          @facility = Facility.find_by('id = ?', params[:facility_id])
          raise_with_message("facility is not found", 404) if @facility.blank?
          raise_with_message("facility is invalid", 400) if @facility.shop.corporation_id != @corporation.id
          @facility_key = @facility.facility_keys.first
          raise_with_message("facility key is not found", 404) if @facility_key.blank?
          @facility_key.update!(ks_room_key_id: params[:ks_room_key_id])
          # KSCの予約から鍵IDの削除
          if @facility_key.facility.rent_with_ksc?
            @facility_key.facility.ksc_reservations_after_today.each do |rsv|
              rsv.update_ksc_reservation
            end
          end
        end

        # 鍵作成
        namespace do
          params do
            requires :facility_id, type: Integer
            requires :ks_room_key_id, type: Integer
          end

          post '/', jbuilder: 'facility_keys/create' do
            @facility = Facility.find_by('id = ?', params[:facility_id])
            raise_with_message("facility is not found", 404) if @facility.blank?
            raise_with_message("facility is invalid", 400) if @facility.shop.corporation_id != @corporation.id
              @facility_key = @facility
                              .facility_keys
                              .create!(ks_room_key_id: params[:ks_room_key_id],
                                       name: "#{@facility.name}")
            # KSCの予約から鍵IDの削除
            if @facility_key.facility.rent_with_ksc?
              @facility_key.facility.ksc_reservations_after_today.each do |rsv|
                rsv.update_ksc_reservation
              end
            end
          end
        end

        # 全鍵削除
        namespace do
          params do
            requires :facility_id, type: Integer
          end

          delete '/', jbuilder: 'facility_keys/destroy' do
            @facility = Facility.find_by('id = ?', params[:facility_id])
            raise_with_message("facility is not found", 404) if @facility.blank?
            raise_with_message("facility is invalid", 400) if @facility.shop.corporation_id != @corporation.id
            @facility.facility_keys.destroy_all
            # KSCの予約から鍵IDの削除
            if @facility.rent_with_ksc?
              @facility.ksc_reservations_after_today.each do |rsv|
                rsv.update_ksc_reservation
              end
            end
          end
        end
      end
    end
  end
end

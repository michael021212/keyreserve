module API
  module V1
    class FacilityKeys < Grape::API
      resource :facility_keys do
        params do
          requires :facility_id, type: Integer
          requires :ks_previous_room_key_id, type: Integer
          requires :ks_room_key_id, type: Integer
        end
        patch '/', jbuilder: 'facility_keys/update' do
          @facility = Facility.find_by('id = ?', params[:facility_id])
          raise_with_message("facility is not found", 404) if @facility.blank?
          # TODO: tokenから取得する@corporationのIDと比較
          # raise_with_message("facility is invalid", 400) if @facility.shop.corporation_id != 10
          @facility_key = @facility.facility_keys.find_by('ks_room_key_id = ?',
                                                          params[:ks_previous_room_key_id])
          raise_with_message("facility key is not found", 404) if @facility_key.blank?
          @facility_key.update!(ks_room_key_id: params[:ks_room_key_id])
        end
      end
    end
  end
end

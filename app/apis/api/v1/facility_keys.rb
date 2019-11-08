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
          raise_with_message("facility is invalid", 400) if @facility.shop.corporation_id != @corporation.id
          @facility_key = @facility.facility_keys.find_by('ks_room_key_id = ?',
                                                          params[:ks_previous_room_key_id])
          raise_with_message("facility key is not found", 404) if @facility_key.blank?
          @facility_key.update!(ks_room_key_id: params[:ks_room_key_id])
        end

        namespace do
          params do
            requires :facility_id, type: Integer
            requires :ks_room_key_id, type: Integer
          end

          post '/', jbuilder: 'facility_keys/create' do
            @facility = Facility.find_by('id = ?', params[:facility_id])
            raise_with_message("facility is not found", 404) if @facility.blank?
            raise_with_message("facility is invalid", 400) if @facility.shop.corporation_id != @corporation.id
            @facility_key = @facility.facility_keys.create!(ks_room_key_id: params[:ks_room_key_id],
                                                            name: "#{@facility.name}")
          end
        end

        # FacilityIDから紐づくkeyを全て削除するAPI
        namespace do
          params do
            requires :facility_id, type: Integer
          end

          delete '/', jbuilder: 'facility_keys/destroy' do
            @facility = Facility.find_by('id = ?', params[:facility_id])
            raise_with_message("facility is not found", 404) if @facility.blank?
            raise_with_message("facility is invalid", 400) if @facility.shop.corporation_id != @corporation.id
            @facility_key = @facility.facility_keys.destroy_all
          end
        end
      end
    end
  end
end

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
          begin
            @facility_key.update!(ks_room_key_id: params[:ks_room_key_id])
            @facility.update_ksc_room if @facility.rent_with_ksc?
            true
          rescue => e
            logger.debug(e)
            raise_with_message("something went wrong", 500)
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
            begin
              @facility_key = @facility.facility_keys.create!(ks_room_key_id: params[:ks_room_key_id],
                                                              name: "#{@facility.name}")
              @facility.update_ksc_room if @facility.rent_with_ksc?
              true
            rescue => e
              logger.debug(e)
              raise_with_message("something went wrong", 500)
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
            begin
              @facility.facility_keys.destroy_all
              @facility.update_ksc_room if @facility.rent_with_ksc?
              true
            rescue => e
              logger.debug(e)
              raise_with_message("something went wrong", 500)
            end
          end
        end

      end
    end
  end
end

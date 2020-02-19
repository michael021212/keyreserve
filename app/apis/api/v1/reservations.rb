module API
  module V1
    class Reservations < Grape::API
      resource :reservations do
        # ブロック予約の作成
        params do
          requires :facility_id, type: Integer
          requires :checkin, type: Integer
          requires :checkout, type: Integer
        end
        post '/block', jbuilder: 'reservations/block' do
          @facility = Facility.find_by('id=?', params[:facility_id])
          checkin = Time.at(params[:checkin])
          checkout = Time.at(params[:checkout])
          usage_period = (checkout - checkin)/60/60
          raise_with_message("facility is not found", 404) if @facility.blank?
          raise_with_message("facility is invalid", 400) if @facility.shop.corporation != @corporation
          begin
            ActiveRecord::Base.transaction do
              @reservation = Reservation.new(
                facility_id: @facility.id,
                checkin: checkin,
                checkout: checkout,
                usage_period: usage_period,
                state: Reservation.states[:confirmed],
                block_flag: true,
                price: 0
              )
              @reservation.save!
            end
          rescue => e
            @error = e.to_s
          end
        end

        # ブロック予約の解除
        params do
          requires :facility_id, type: Integer
          requires :checkin, type: Integer
          requires :checkout, type: Integer
        end
        delete '/block', jbuilder: 'reservations/destroy_block' do
          begin
            @facility = Facility.find_by('id=?', params[:facility_id])
            checkin = Time.at(params[:checkin])
            checkout = Time.at(params[:checkout])
            raise_with_message("facility is not found", 404) if @facility.blank?
            raise_with_message("facility is invalid", 400) if @facility.shop.corporation != @corporation
            @reservation = Reservation.find_by('checkin = ? && checkout = ? && facility_id = ?', checkin, checkout, @facility.id)
            raise_with_message("reservation is not found", 400) if @reservation.blank?
            raise_with_message("reservation type is not block", 400) if !@reservation.block_flag
            @reservation.delete
          rescue => e
            @error = e.to_s
          end
        end

      end
    end
  end
end


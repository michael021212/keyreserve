Ransack.configure do |config|
  config.add_predicate :during_month,
                       arel_predicate: :between,
                       formatter: proc { |v|
                         v.beginning_of_month.beginning_of_day.to_datetime..v.end_of_month.end_of_day.to_datetime
                       },
                       type: :date
end

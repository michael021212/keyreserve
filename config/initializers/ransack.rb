Ransack.configure do |config|
  config.add_predicate :during_month,
                       arel_predicate: :between,
                       formatter: proc { |v|
                         v.beginning_of_month.to_date...v.end_of_month.to_date
                       },
                       type: :date
end

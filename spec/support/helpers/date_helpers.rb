module DateHelper
  def select_date(target_model, target_column, date)
    select "#{date.year}", from: "#{target_model}[#{target_column}(1i)]"
    select "#{date.month}", from: "#{target_model}[#{target_column}(2i)]"
    select "#{date.day}", from: "#{target_model}[#{target_column}(3i)]"
  end
end

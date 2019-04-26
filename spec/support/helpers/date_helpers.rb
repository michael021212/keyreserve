module DateHelper
  def select_date(target_model, target_column, date)
    select date.year, from: "#{target_model}[#{target_column}(1i)]"
    select date.month, from: "#{target_model}[#{target_column}(2i)]"
    select date.day, from: "#{target_model}[#{target_column}(3i)]"
  end
  
  def select_datetime(target_model, target_column, datetime)
    select datetime.year, from: "#{target_model}[#{target_column}(1i)]"
    select datetime.month, from: "#{target_model}[#{target_column}(2i)]"
    select datetime.day, from: "#{target_model}[#{target_column}(3i)]"
    select datetime.hour, from: "#{target_model}[#{target_column}(4i)]"
    select datetime.minute, from: "#{target_model}[#{target_column}(5i)]"
  end
end

module ReservationHelper

  def reservable_usage(ary=[], usage=0.5)
    while usage <= 24 do
      ary << ["#{ usage.to_s }時間", usage]
      usage += 0.5
    end
    ary
  end

  def selectable_num
    (1..20).map{ |i| [i.to_s + '名', i] }
  end
end

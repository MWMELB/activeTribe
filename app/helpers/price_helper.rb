module PriceHelper
  def format_price(price)
    if price == 0
      "Free"
    else
      "$#{price}"
    end
  end
end

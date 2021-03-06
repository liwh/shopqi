class Admin::ShippingController < Admin::AppController
  prepend_before_filter :authenticate_user!
  layout 'admin'

  expose(:shop){ current_user.shop }
  expose(:countries){ shop.countries }
  expose(:country)
  expose(:weight_based_shipping_rate)
  expose(:price_based_shipping_rate)
end

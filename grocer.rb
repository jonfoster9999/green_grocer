require 'pry'
def consolidate_cart(cart)
  new_cart = {}

  cart.each do |item|
    new_cart[item.keys[0]] = new_cart[item.keys[0]] || item.values[0].merge(:count => 0)
    new_cart[item.keys[0]][:count] += 1
  end
  new_cart
end

def apply_coupons(cart, coupons)
  new_items = {}
  coupons.each do |coupon|
    cart.each do |item, info|
      if coupon[:item] == item
        coupon_num = coupon[:num]
        if coupon_num <= info[:count]
          info[:count] -= coupon_num
          new_price = coupon[:cost].to_f / coupon_num.to_f
          new_name = "#{item} W/COUPON"
          if new_items[new_name]
            new_items[new_name][:count] += coupon_num
          else
            new_items[new_name] = info.merge(
              :price => new_price, :count => coupon_num
            )
          end
        end
      end
    end
  end

  cart.merge(new_items)
end

def apply_clearance(cart)
  cart.each do |name, item|
    item[:price] = (item[:price] * 0.8).round(2) if item[:clearance]
  end
  cart
end

def checkout(cart, coupons)
  total = 0
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart= apply_clearance(cart)

  cart.each do |name, item|
    total += (item[:price] * item[:count])
  end
  return total <= 100 ? total : (total * 0.9).round(2)
end

default_color = {255, 255, 255}
hp_color = {255, 0, 0}
mana_color = {0, 0, 255}

-- poison_color = {106, 190, 48}

-- Elements
fire_color = {220, 73, 58} -- #DC493A
poison_color = {0, 168, 120} -- #00A878
water_color = {27, 82, 153} -- #1B5299
ice_color = {102, 215, 209} -- #66D7D1
lightning_color = {226, 132, 19} -- #E28413
blood_color = {106, 190, 48} -- #C42847
death_color = {30, 30, 36} -- #1E1E24
holy_color = {251, 245, 243} -- #FBF5F3

default_colors = {default_color, hp_color, mana_color}
negative_colors = {
  {255-default_color[1], 255-default_color[2], 255-default_color[3]},
  {255-hp_color[1], 255-hp_color[2], 255-hp_color[3]},
  {255-mana_color[1], 255-mana_color[2], 255-mana_color[3]},
}

all_colors = fn.append(default_colors, negative_colors)

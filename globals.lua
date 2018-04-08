default_color = {1, 1, 1, 1}
hp_color = {1, 0, 0, 1}
mana_color = {0, 0, 1, 1}

-- Elements
fire_color = {0.862745, 0.286275, 0.227451, 1} -- #DC493A, {220, 73, 58}
poison_color = {0, 0.658824, 0.470588, 1} -- #00A878, {0, 168, 120}
water_color = {0.105882, 0.321569, 0.6, 1} -- #1B5299, {27, 82, 153}
ice_color = {0.4, 0.843137, 0.819608, 1} -- #66D7D1, {102, 215, 209}
lightning_color = {0.886275, 0.517647, 0.07451, 1} -- #E28413, {226, 132, 19}
blood_color = {0.415686, 0.745098, 0.188235, 1} -- #C42847, {106, 190, 48}
death_color = {0.117647, 0.117647, 0.141176, 1} -- #1E1E24, {30, 30, 36}
holy_color = {0.984314, 0.960784, 0.952941, 1} -- #FBF5F3, {251, 245, 243}

default_colors = {default_color, hp_color, mana_color}
negative_colors = {
  {1-default_color[1], 1-default_color[2], 1-default_color[3]},
  {1-hp_color[1], 1-hp_color[2], 1-hp_color[3]},
  {1-mana_color[1], 1-mana_color[2], 1-mana_color[3]},
}

all_colors = fn.append(default_colors, negative_colors)

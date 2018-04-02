default_color = {255, 255, 255}
hp_color = {255, 0, 0}
mana_color = {0, 0, 255}

default_colors = {default_color, hp_color, mana_color}
negative_colors = {
  {255-default_color[1], 255-default_color[2], 255-default_color[3]},
  {255-hp_color[1], 255-hp_color[2], 255-hp_color[3]},
  {255-mana_color[1], 255-mana_color[2], 255-mana_color[3]},
}

all_colors = fn.append(default_colors, negative_colors)

Elementalist = Player:extend()

function Elementalist:new(area, x, y, opts)
  Elementalist.super.new(self, area, x, y, opts)

  self.v_max = 110

  self.mana = 200
  self.max_mana = 200
  self.mana_regen = 20

  self.hp = 100
  self.max_hp = 100

  self.equipped_skills = {
    ['skill_slot_1'] = Skill(),
    ['skill_slot_2'] = Fireball(),
    ['skill_slot_3'] = PoisonDart(),
    ['skill_slot_4'] = Icewall()
  }
end

function Elementalist:destroy()
  Elementalist.super.destroy(self)
end

function Elementalist:update(dt)
  Elementalist.super.update(self, dt)
end

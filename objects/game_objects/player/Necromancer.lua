Necromancer = Player:extend()

function Necromancer:new(area, x, y, opts)
  Necromancer.super.new(self, area, x, y, opts)

  self.v_max = 90

  self.mana = 100
  self.max_mana = 100
  self.mana_regen = 10

  self.hp = 150
  self.max_hp = 150

  self.equipped_skills = {
    ['skill_slot_1'] = PoisonDart(),
    ['skill_slot_2'] = PoisonDart(),
    ['skill_slot_3'] = PoisonDart(),
    ['skill_slot_4'] = PoisonDart()
  }
end

function Necromancer:destroy()
  Necromancer.super.destroy(self)
end

function Necromancer:update(dt)
  Necromancer.super.update(self, dt)
end

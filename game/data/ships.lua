BaseShip = Object.extend(Object)
function BaseShip:new(x, y, length, width, color, letter)
    -- Shape of the ship. Generally, the length will be longer.
    self.length = length
    self.width = width

    -- Location of the ship. Use top left of ship as coordinate.
    self.x = x
    self.y = y

    self.color = color
    self.letter = letter


    -- Create the table to represent the health of the ship


end

Carrier = BaseShip:extend()
function Carrier:new(x, y)  -- Orange
    Carrier.super.new(self, x, y, 5, 1, {.972, .67, .266}, "c")

    self.x = x
    self.y = y
end

Battleship = BaseShip:extend()
function Battleship:new(x, y)  -- Red
    Battleship.super.new(self, x, y, 4, 1, {.972, .266, .603}, "b")

    self.x = x
    self.y = y
end

Cruiser = BaseShip:extend()
function Cruiser:new(x, y)  -- Yellow
    Cruiser.super.new(self, x, y, 3, 1, {.694, .972, .266}, "r")

    self.x = x
    self.y = y
end

Submarine = BaseShip:extend()
function Submarine:new(x, y)  -- Green
    Submarine.super.new(self, x, y, 3, 1, {.266, .972, .611}, "s")

    self.x = x
    self.y = y
end

Destroyer = BaseShip:extend()
function Destroyer:new(x, y)  -- Pink
    Destroyer.super.new(self, x, y, 2, 1, {.960, .266, .972}, "d")

    self.x = x
    self.y = y
end

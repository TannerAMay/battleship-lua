BaseShip = Object.extend(Object)

function BaseShip:new(x, y, length, width)
    -- Shape of the ship. Generally, the length will be longer.
    self.length = length
    self.width = width

    -- Location of the ship. Use top left of ship as coordinate.
    self.x = x
    self.y = y

    -- Create the table to represent the health of the ship


end
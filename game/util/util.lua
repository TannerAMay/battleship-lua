function checkRectCollision(checkX, checkY, x, y, width, height)
    if (checkX < x or checkX > x+width or checkY < y or checkY > y + height)
    then
        return false
    end
    
    return true
end
------------------------------------------------------------------------------------------------
-- The collision2d module.
--
-- @module  collision2d
-- @author Łukasz Durniat
-- @license MIT
-- @copyright Łukasz Durniat, Nov-2024
------------------------------------------------------------------------------------------------

-- ------------------------------------------------------------------------------------------ --
--                                 REQUIRED MODULES                                           --
-- ------------------------------------------------------------------------------------------ --
local vector2d = require("vector2d")

-- ------------------------------------------------------------------------------------------ --
--                                 MODULE DECLARATION                                         --
-- ------------------------------------------------------------------------------------------ --

local M = {}

-- ------------------------------------------------------------------------------------------ --
--                                 PRIVATE METHODS                                            --
-- ------------------------------------------------------------------------------------------ --

-- Checks for collision between two display objects representing circles using the vector2d library.
--
-- @param `circle1`: The first display object with properties:
--                   `x` (x-coordinate of the center),
--                   `y` (y-coordinate of the center),
--                   `path.radius` (the radius of the circle).
-- @param `circle2`: The second display object with properties:
--                   `x` (x-coordinate of the center),
--                   `y` (y-coordinate of the center),
--                   `path.radius` (the radius of the circle).
--
-- @return `true` if the circles collide, `false` otherwise.
function M.circleVsCircle(circle1, circle2)
    -- Calculate the distance between the centers using vector2d's distance function
    local distance = vector2d.distance(circle1, circle2)

    -- Check if the distance is less than or equal to the sum of the radii
    return distance <= (circle1.path.radius + circle2.path.radius)
end

-- Function to check collision between two display object rectangles
-- The rectangles are not necessarily centered (anchor points can vary).
-- This function considers both the position and rotation of the rectangles.
--
-- @param `rect1`: The first display object rectangle.
-- @param `rect2`: The second display object rectangle.
--
-- @return `true` if the rectangles collide, `false` otherwise.
function M.rectVsRect(rect1, rect2)
    -- Get the center position and size of the rectangles
    local x1, y1 = rect1.x, rect1.y
    local x2, y2 = rect2.x, rect2.y
    local width1, height1 = rect1.width, rect1.height
    local width2, height2 = rect2.width, rect2.height
    local rotation1, rotation2 = rect1.rotation, rect2.rotation

    -- Calculate the half-extents (half of width and height) for both rectangles
    local hw1, hh1 = width1 / 2, height1 / 2
    local hw2, hh2 = width2 / 2, height2 / 2

    -- Convert the rotations to radians
    local radians1 = math.rad(rotation1)
    local radians2 = math.rad(rotation2)

    -- Define the corners of the rectangles
    local corners1 = {
        {x = -hw1, y = -hh1}, {x = hw1, y = -hh1}, 
        {x = hw1, y = hh1}, {x = -hw1, y = hh1}
    }
    local corners2 = {
        {x = -hw2, y = -hh2}, {x = hw2, y = -hh2}, 
        {x = hw2, y = hh2}, {x = -hw2, y = hh2}
    }

    -- Rotate and translate the corners for both rectangles
    local function rotateAndTranslate(corners, x, y, radians)
        local rotatedCorners = {}
        for _, corner in ipairs(corners) do
            local cosTheta = math.cos(radians)
            local sinTheta = math.sin(radians)
            local xRot = corner.x * cosTheta - corner.y * sinTheta + x
            local yRot = corner.x * sinTheta + corner.y * cosTheta + y
            table.insert(rotatedCorners, {x = xRot, y = yRot})
        end
        return rotatedCorners
    end

    -- Get the rotated corners of both rectangles
    local rotatedCorners1 = rotateAndTranslate(corners1, x1, y1, radians1)
    local rotatedCorners2 = rotateAndTranslate(corners2, x2, y2, radians2)

    -- Check if any of the corners of one rectangle are inside the other rectangle
    local function isPointInsideRectangle(x, y, rectCorners)
        local sign = function(x1, y1, x2, y2, x3, y3)
            return (x1 - x3) * (y2 - y3) - (x2 - x3) * (y1 - y3)
        end

        local inside = true
        for i = 1, 4 do
            local j = (i % 4) + 1
            if sign(rectCorners[i].x, rectCorners[i].y, rectCorners[j].x, rectCorners[j].y, x, y) < 0 then
                inside = false
                break
            end
        end
        return inside
    end

    -- Check if any corner of one rectangle is inside the other
    for _, corner1 in ipairs(rotatedCorners1) do
        if isPointInsideRectangle(corner1.x, corner1.y, rotatedCorners2) then
            return true
        end
    end
    for _, corner2 in ipairs(rotatedCorners2) do
        if isPointInsideRectangle(corner2.x, corner2.y, rotatedCorners1) then
            return true
        end
    end

    return false
end

return M

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

return M

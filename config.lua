return {
    ProgressTime = 5000,
    Cooldown = {
        enable = true,
        time = 30, -- seconds
    },
    BlacklistedJobs = {
        police = true,
        ambulance = true,
    },
    AlertPolice = function(coords)
        if math.random() > 0.1 then return end -- low alert chance by default.
        -- insert dispatch alert here using coords passed in if you need.
    end,
}
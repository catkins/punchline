local key = KEYS[1]

-- fetch the lowest priority value
local score = redis.call("ZRANGE", key, 0, 0, "WITHSCORES")

-- delete the smallest value
redis.call("ZREMRANGEBYRANK", key, 0, 0)

return score

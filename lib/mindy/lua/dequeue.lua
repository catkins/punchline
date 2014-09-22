-- fetch the lowest priority value
local score = redis.call("ZRANGE", KEYS[1], 0, 0, "WITHSCORES")

-- delete the smallest value
redis.call("ZREMRANGEBYRANK", KEYS[1], 0, 0)

return score

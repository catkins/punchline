local score = redis.call("ZRANGE", KEYS[1], 0, 0, "WITHSCORES")

redis.call("ZREMRANGEBYRANK", KEYS[1], 0, 0)

return score

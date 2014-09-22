local key = KEYS[1]
local priority = tonumber(ARGV[1])
local value = ARGV[2]

local current_score = tonumber(redis.call("ZSCORE", key, value))

-- first time key has been added
if current_score == nil then
  redis.call("ZADD", key, priority, value)
  return 1
end

-- only add if it's a lower priority
if priority < current_score then
  redis.call("ZADD", key, priority, value)
  return 1
end

return 0


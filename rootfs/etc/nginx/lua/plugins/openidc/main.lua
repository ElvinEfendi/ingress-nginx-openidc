local resty_openidc = require("resty.openidc")

local _M = {}

function _M.rewrite()
  ngx.log(ngx.WARN, "heyoo, I'm in rewrite")

  local res, err = resty_openidc.authenticate({})
  ngx.log(ngx.WARN, err)
end

function _M.log()
  ngx.log(ngx.ERR, "ooooooooooo XIYAR")
end

return _M

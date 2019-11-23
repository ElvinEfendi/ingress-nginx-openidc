local resty_openidc = require("resty.openidc")

local _M = {}

local CLIENT_ID = os.getenv("OPENIDC_CLIENT_ID")
local CLIENT_SECRET = os.getenv("OPENIDC_CLIENT_SECRET")

local opts = {
  -- For full list of options see https://github.com/zmartzone/lua-resty-openidc

  redirect_uri = "https://example.com/redirect_uri",
  discovery = "https://accounts.google.com/.well-known/openid-configuration",
  client_id = CLIENT_ID,
  client_secret = CLIENT_SECRET,
}

function _M.rewrite()
  -- Here you can use ngx.var.proxy_upstream_name to identify backend and apply the
  -- following logic only to certain backends. Or you can use ngx.var.best_http_host
  -- to filter based on front end (a.k.a domain/host). For example below we say
  -- that do not apply this logic to default backend.

  if ngx.var.proxy_upstream_name == "upstream-default-backend" then
    return
  end

  local res, err = resty_openidc.authenticate(opts)
  if err then
    ngx.status = 500
    ngx.say(err)
    ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
  end

  -- This is only an example, normally here you'd want to enforce
  -- authentication or authorization or set some information in the request header
  -- to be passed to the usptream. For more information check out https://github.com/zmartzone/lua-resty-openidc.
  ngx.say("Hello, ", res.user.email)
end

return _M

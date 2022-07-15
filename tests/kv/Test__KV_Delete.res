include Workers.Make({
  type env = {kv: Workers.Kv.t}

  let handlers = Workers.Handlers.make(~fetch=(req, {kv}, _) => {
    let url = req->Webapi.Fetch.Request.url->Webapi.Url.make
    let searchParams = url->Webapi.Url.searchParams

    let key = searchParams->Webapi.Url.URLSearchParams.get("key")->Belt.Option.getExn

    Workers.Kv.delete(~namespace=kv, ~key, ())->Promise.thenResolve(Test__Utils.makeJsonResp)
  }, ())
})

include Workers.Make({
  type env = {kv: Workers.Kv.t}

  let handlers = Workers.Handlers.make(~fetch=(req, {kv}, _) => {
    let url = req->Webapi.Fetch.Request.url->Webapi.Url.make
    let pathname = url->Webapi.Url.pathname
    let searchParams = url->Webapi.Url.searchParams

    switch pathname {
    | "/list" => Workers.Kv.list(~namespace=kv, ())->Promise.thenResolve(Test__Utils.makeJsonResp)
    | "/getJson" => {
        let key = searchParams->Webapi.Url.URLSearchParams.get("key")->Belt.Option.getExn
        Workers.Kv.getJson(~namespace=kv, ~key, ())->Promise.thenResolve(Test__Utils.makeJsonResp)
      }
    | _ =>
      ""
      ->Webapi.Fetch.Response.makeWithInit(Webapi.Fetch.ResponseInit.make(~status=404, ()))
      ->Promise.resolve
    }
  }, ())
})

include Workers.Make({
  type env = {kv: Workers.Kv.t}

  let handlers = Workers.Handlers.make(~fetch=(req, {kv}, _) => {
    let url = req->Webapi.Fetch.Request.url->Webapi.Url.make
    let searchParams = url->Webapi.Url.searchParams

    let prefix = searchParams->Webapi.Url.URLSearchParams.get("prefix")
    let cursor = searchParams->Webapi.Url.URLSearchParams.get("cursor")
    let limit =
      searchParams
      ->Webapi.Url.URLSearchParams.get("limit")
      ->Belt.Option.flatMap(Belt.Int.fromString)

    Workers.Kv.list(
      ~namespace=kv,
      ~opts=Workers.Kv.List.makeOpts(~prefix?, ~cursor?, ~limit?, ()),
      (),
    )->Promise.thenResolve(Test__Utils.makeJsonResp)
  }, ())
})

include Workers.Make({
  type env = {kv: Workers.Kv.t}

  let handlers = Workers.Handlers.make(~fetch=(req, {kv}, _) => {
    let url = req->Webapi.Fetch.Request.url->Webapi.Url.make
    let searchParams = url->Webapi.Url.searchParams

    let key = searchParams->Webapi.Url.URLSearchParams.get("key")->Belt.Option.getExn
    let ty =
      searchParams->Webapi.Url.URLSearchParams.get("type")->Belt.Option.getWithDefault("json")
    let meta =
      searchParams
      ->Webapi.Url.URLSearchParams.get("meta")
      ->Belt.Option.map(s => s == "true")
      ->Belt.Option.getWithDefault(false)

    switch ty {
    | "json" =>
      switch meta {
      | false =>
        Workers.Kv.getJson(~namespace=kv, ~key, ())->Promise.thenResolve(Test__Utils.makeJsonResp)
      | true =>
        Workers.Kv.getJsonWithMetadata(~namespace=kv, ~key, ())->Promise.thenResolve(
          Test__Utils.makeJsonResp,
        )
      }

    | "text" =>
      switch meta {
      | false =>
        Workers.Kv.getText(~namespace=kv, ~key, ())->Promise.thenResolve(Webapi.Fetch.Response.make)
      | true =>
        Workers.Kv.getTextWithMetadata(~namespace=kv, ~key, ())->Promise.thenResolve(
          Test__Utils.makeJsonResp,
        )
      }
    | "stream" =>
      switch meta {
      | false =>
        Workers.Kv.getStream(~namespace=kv, ~key, ())->Promise.thenResolve(
          %raw(`(v) => new Response(v)`),
        )
      | true => Promise.resolve(Test__Utils.makeJsonResp({"error": "unsupported operation"}))
      }
    | _ => {
        let error = "unsupported type: " ++ ty
        Promise.resolve(Test__Utils.makeJsonResp({"error": error}))
      }
    }
  }, ())
})

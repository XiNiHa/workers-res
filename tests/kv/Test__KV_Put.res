include Workers.Make({
  type env = {kv: Workers.Kv.t}

  let handlers = Workers.Handlers.make(~fetch=(req, {kv}, _) => {
    req
    ->Webapi.Fetch.Request.json
    ->Promise.then(body => {
      let casted = %raw(`(x) => x`)(body)
      let key = casted["key"]
      let value = casted["value"]
      let metadata = casted["metadata"]

      Workers.Kv.putText(
        ~namespace=kv,
        ~key,
        ~value,
        ~opts=Workers.Kv.Put.makeOpts(~metadata, ()),
        (),
      )
    })
    ->Promise.thenResolve(Test__Utils.makeJsonResp)
  }, ())
})

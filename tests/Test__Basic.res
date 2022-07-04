include Workers.Make({
  type env = unit

  let handlers = Workers.Handlers.make(~fetch=(_, _, _) => {
    "Hello world!"->Webapi.Fetch.Response.make->Js.Promise.resolve
  }, ())
})

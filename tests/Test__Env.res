include Workers.Make({
  type env = {theAnswer: int}

  let handlers = Workers.Handlers.make(~fetch=(_, {theAnswer}, _) => {
    j`The answer is: $theAnswer`->Webapi.Fetch.Response.make->Js.Promise.resolve
  }, ())
})

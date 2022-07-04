let default = Workers.make(~fetch=(req, _, _) => {
  req
  ->Webapi.Fetch.Request.text
  ->Promise.thenResolve(body =>
    body
    ->Js.String2.split("")
    ->Js.Array2.reverseInPlace
    ->Js.Array2.joinWith("")
    ->Webapi.Fetch.Response.make
  )
}, ())

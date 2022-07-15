let makeJsonResp = data => {
  {"value": data}
  ->Js.Json.stringifyAny
  ->Belt.Option.getExn
  ->Webapi.Fetch.Response.makeWithInit(
    Webapi.Fetch.ResponseInit.make(
      ~headers=Webapi.Fetch.HeadersInit.make({"Content-Type": "application/json"}),
      (),
    ),
  )
}

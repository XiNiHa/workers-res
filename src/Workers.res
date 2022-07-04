type t

module Fetch = {
  type context
  type handler<'env> = (
    Webapi.Fetch.Request.t,
    'env,
    context,
  ) => Js.Promise.t<Webapi.Fetch.Response.t>

  module Context = {
    @send external waitUntil: (context, Js.Promise.t<'a>) => unit = "waitUntil"
    @send external passThroughOnException: context => unit = "passThroughOnException"
  }
}

module Scheduled = {
  type event
  type context
  type handler<'env> = (
    event,
    'env,
    context,
  ) => Js.Promise.t<unit>

  module Context = {
    @send external waitUntil: (context, Js.Promise.t<'a>) => unit = "waitUntil"
  }
}

@obj
external make: (~fetch: Fetch.handler<'env>=?, ~scheduled: Scheduled.handler<'env>=?, unit) => t = ""

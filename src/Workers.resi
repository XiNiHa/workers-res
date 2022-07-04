type t

module Fetch: {
  type context
  type handler<'env> = (
    Webapi.Fetch.Request.t,
    'env,
    context,
  ) => Js.Promise.t<Webapi.Fetch.Response.t>

  module Context: {
    let waitUntil: (context, Js.Promise.t<'a>) => unit
    let passThroughOnException: context => unit
  }
}

module Scheduled: {
  type event
  type context
  type handler<'env> = (event, 'env, context) => Js.Promise.t<unit>

  module Context: {
    let waitUntil: (context, Js.Promise.t<'a>) => unit
  }
}

module Handlers: {
  type t<'env>

  let make: (~fetch: Fetch.handler<'env>=?, ~scheduled: Scheduled.handler<'env>=?, unit) => t<'env>
}

module Make: (
  T: {
    type env
    let handlers: Handlers.t<env>
  },
) =>
{
  type exports

  let default: exports
}

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
  type handler<'env> = (event, 'env, context) => Js.Promise.t<unit>

  module Context = {
    @send external waitUntil: (context, Js.Promise.t<'a>) => unit = "waitUntil"
  }
}

module Handlers = {
  type t<'env> = {
    fetch: option<Fetch.handler<'env>>,
    scheduled: option<Scheduled.handler<'env>>,
  }

  @obj
  external make: (
    ~fetch: Fetch.handler<'env>=?,
    ~scheduled: Scheduled.handler<'env>=?,
    unit,
  ) => t<'env> = ""
}

module Make = (
  T: {
    type env

    let handlers: Handlers.t<env>
  },
) => {
  type exports = {
    fetch: option<Fetch.handler<T.env>>,
    scheduled: option<Scheduled.handler<T.env>>,
  }

  let default = {fetch: T.handlers.fetch, scheduled: T.handlers.scheduled}
}

module Kv = Workers__Kv

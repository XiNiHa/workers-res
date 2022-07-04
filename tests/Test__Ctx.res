let counter = ref(0)

let default = Workers.make(~fetch=(_, _, ctx) => {
  counter := counter.contents + 1

  ctx->Workers.Fetch.Context.waitUntil(
    Promise.make((resolve, _) =>
      Js.Global.setTimeout(() => resolve(. Js.Nullable.null), 5000)->ignore
    ),
  )

  let count = counter.contents
  j`Counter increased to $count`->Webapi.Fetch.Response.make->Js.Promise.resolve
}, ())

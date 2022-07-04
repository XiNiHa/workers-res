let counter = ref(0)

include Workers.Make({
  type env = unit

  let handlers = Workers.Handlers.make(
    ~fetch=(_, _, _) => {
      counter.contents->Belt.Int.toString->Webapi.Fetch.Response.make->Js.Promise.resolve
    },
    ~scheduled=(_, _, _) => {
      counter := counter.contents + 1
      Promise.resolve()
    },
    (),
  )
})

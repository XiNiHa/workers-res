let default = Workers.make(
  ~fetch=(_, _, _) => {
    "Hello world!"
    ->Webapi.Fetch.Response.make
    ->Js.Promise.resolve
  },
  ()
)

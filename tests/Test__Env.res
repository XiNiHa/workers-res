type env = {
  theAnswer: int
}

let default = Workers.make(
  ~fetch=(_, { theAnswer }, _) => {
    j`The answer is: $theAnswer`
    ->Webapi.Fetch.Response.make
    ->Js.Promise.resolve
  },
  ()
)

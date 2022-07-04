# workers-res

Cloudflare Workers bindings for ReScript, WIP

# Example

```res
let default = Workers.make(
  ~fetch=(_, _, _) => {
    "Hello, world!"
    ->Webapi.Fetch.Response.make
    ->Js.Promise.resolve
  },
  ()
)
```

# Features

- [x] Module format Worker bindings
- [ ] KV
- [ ] R2
- [ ] DO
- [ ] HTMLRewriter
- [ ] ???

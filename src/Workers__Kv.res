type t

module List = {
  type opts
  type key<'metadata> = {name: string, expiration: option<int>, metadata: 'metadata}
  type res<'metadata> = {keys: array<key<'metadata>>, list_complete: bool, cursor: option<string>}

  @obj
  external makeOpts: (~prefix: string=?, ~limit: int=?, ~cursor: string=?, unit) => opts = ""

  @send external list: (~namespace: t, ~opts: opts=?, unit) => Js.Promise.t<res<'m>> = "list"
}

module Get = {
  type opts = {cacheTtl: option<int>}
  type inneropts
  type valueWithMeta<'v, 'm> = {value: option<'v>, metadata: option<'m>}
  type getForType<'v> = (~namespace: t, ~key: string, ~opts: opts=?, unit) => Js.Promise.t<'v>

  @obj
  external __makeOpts: (~\"type": string, ~cacheTtl: option<int>) => inneropts = ""

  let makeOpts = (~cacheTtl=?, ()) => {
    {cacheTtl: cacheTtl}
  }

  @send
  external get: (~namespace: t, ~key: string, ~opts: inneropts=?, unit) => Js.Promise.t<'a> = "get"
  @send
  external getWithMetadata: (
    ~namespace: t,
    ~key: string,
    ~opts: inneropts=?,
    unit,
  ) => Js.Promise.t<valueWithMeta<'v, 'm>> = "getWithMetadata"

  let getForType = (~namespace, ~key, ~type_, ~opts, ()) => {
    get(
      ~namespace,
      ~key,
      ~opts=__makeOpts(~\"type"=type_, ~cacheTtl=opts->Belt.Option.flatMap(opts => opts.cacheTtl)),
      (),
    )
  }
  let getForTypeWithMetadata = (~namespace, ~key, ~type_, ~opts, ()) => {
    getWithMetadata(
      ~namespace,
      ~key,
      ~opts=__makeOpts(~\"type"=type_, ~cacheTtl=opts->Belt.Option.flatMap(opts => opts.cacheTtl)),
      (),
    )
  }

  let getText = (~namespace, ~key, ~opts=?, ()) =>
    getForType(~namespace, ~key, ~opts, ~type_="text", ())
  let getJson = (~namespace, ~key, ~opts=?, ()) =>
    getForType(~namespace, ~key, ~opts, ~type_="json", ())
  let getAny = (~namespace, ~key, ~opts=?, ()) =>
    getForType(~namespace, ~key, ~opts, ~type_="json", ())
  let getArrayBuffer = (~namespace, ~key, ~opts=?, ()) =>
    getForType(~namespace, ~key, ~opts, ~type_="arrayBuffer", ())
  let getStream = (~namespace, ~key, ~opts=?, ()) =>
    getForType(~namespace, ~key, ~opts, ~type_="stream", ())

  let getTextWithMetadata = (~namespace, ~key, ~opts=?, ()) =>
    getForTypeWithMetadata(~namespace, ~key, ~opts, ~type_="text", ())
  let getJsonWithMetadata = (~namespace, ~key, ~opts=?, ()) =>
    getForTypeWithMetadata(~namespace, ~key, ~opts, ~type_="json", ())
  let getAnyWithMetadata = (~namespace, ~key, ~opts=?, ()) =>
    getForTypeWithMetadata(~namespace, ~key, ~opts, ~type_="json", ())
  let getArrayBufferWithMetadata = (~namespace, ~key, ~opts=?, ()) =>
    getForTypeWithMetadata(~namespace, ~key, ~opts, ~type_="arrayBuffer", ())
  let getStreamWithMetadata = (~namespace, ~key, ~opts=?, ()) =>
    getForTypeWithMetadata(~namespace, ~key, ~opts, ~type_="stream", ())
}

module Put = {
  type opts
  type put<'v> = (
    ~namespace: t,
    ~key: string,
    ~value: 'v,
    ~opts: opts=?,
    unit,
  ) => Js.Promise.t<unit>

  @obj
  external makeOpts: (~expiration: int=?, ~expirationTtl: int=?, ~metadata: 'a=?, unit) => opts = ""

  @send
  external putText: (
    ~namespace: t,
    ~key: string,
    ~value: string,
    ~opts: opts=?,
    unit,
  ) => Js.Promise.t<unit> = "put"
  @send
  external putArrayBuffer: (
    ~namespace: t,
    ~key: string,
    ~value: Js.TypedArray2.ArrayBuffer.t,
    ~opts: opts=?,
    unit,
  ) => Js.Promise.t<unit> = "put"
  @send
  external putDataView: (
    ~namespace: t,
    ~key: string,
    ~value: Js.TypedArray2.DataView.t,
    ~opts: opts=?,
    unit,
  ) => Js.Promise.t<unit> = "put"
  @send
  external putStream: (
    ~namespace: t,
    ~key: string,
    ~value: Webapi.ReadableStream.t,
    ~opts: opts=?,
    unit,
  ) => Js.Promise.t<unit> = "put"
}

module Delete = {
  @send external delete: (~namespace: t, ~key: string, unit) => Js.Promise.t<unit> = "delete"
}

let list = List.list

let getText = Get.getText
let getJson = Get.getJson
let getAny = Get.getAny
let getArrayBuffer = Get.getArrayBuffer
let getStream = Get.getStream

let getTextWithMetadata = Get.getTextWithMetadata
let getJsonWithMetadata = Get.getJsonWithMetadata
let getAnyWithMetadata = Get.getAnyWithMetadata
let getArrayBufferWithMetadata = Get.getArrayBufferWithMetadata
let getStreamWithMetadata = Get.getStreamWithMetadata

let putText = Put.putText
let putArrayBuffer = Put.putArrayBuffer
let putDataView = Put.putDataView
let putStream = Put.putStream

let delete = Delete.delete

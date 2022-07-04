type t

module List: {
  type opts
  type key<'metadata> = {name: string, expiration: option<int>, metadata: 'metadata}
  type res<'metadata> = {keys: array<key<'metadata>>, list_complete: bool, cursor: option<string>}

  let makeOpts: (
    ~prefix: option<string>=?,
    ~limit: option<int>=?,
    ~cursor: option<string>=?,
    unit,
  ) => opts
  let list: (~namespace: t, ~opts: opts=?, unit) => Js.Promise.t<res<'m>>
}

module Get: {
  type opts
  type inneropts
  type valueWithMeta<'v, 'm> = {value: option<'v>, metadata: option<'m>}
  type getForType<'v> = (~namespace: t, ~key: string, ~opts: opts=?, unit) => Js.Promise.t<'v>

  let makeOpts: (~cacheTtl: int=?, unit) => opts

  let getText: getForType<string>
  let getJson: getForType<Js.Json.t>
  let getAny: getForType<'a>
  let getArrayBuffer: getForType<Js.TypedArray2.ArrayBuffer.t>
  let getStream: getForType<Webapi.ReadableStream.t>

  let getTextWithMetadata: getForType<valueWithMeta<string, 'm>>
  let getJsonWithMetadata: getForType<valueWithMeta<Js.Json.t, 'm>>
  let getAnyWithMetadata: getForType<valueWithMeta<'a, 'm>>
  let getArrayBufferWithMetadata: getForType<valueWithMeta<Js.TypedArray2.ArrayBuffer.t, 'm>>
  let getStreamWithMetadata: getForType<valueWithMeta<Webapi.ReadableStream.t, 'm>>
}

module Put: {
  type opts

  let makeOpts: (
    ~expiration: option<int>=?,
    ~expirationTtl: option<int>=?,
    ~metadata: option<'a>=?,
    unit,
  ) => opts

  type put<'v> = (
    ~namespace: t,
    ~key: string,
    ~value: 'v,
    ~opts: option<opts>=?,
    unit,
  ) => Js.Promise.t<unit>

  let putText: put<string>
  let putArrayBuffer: put<Js.TypedArray2.ArrayBuffer.t>
  let putDataView: put<Js.TypedArray2.DataView.t>
  let putStream: put<Webapi.ReadableStream.t>
}

let list: (~namespace: t, ~opts: List.opts=?, unit) => Js.Promise.t<List.res<'m>>

let getText: Get.getForType<string>
let getJson: Get.getForType<Js.Json.t>
let getAny: Get.getForType<'a>
let getArrayBuffer: Get.getForType<Js.TypedArray2.ArrayBuffer.t>
let getStream: Get.getForType<Webapi.ReadableStream.t>

let getTextWithMetadata: Get.getForType<Get.valueWithMeta<string, 'm>>
let getJsonWithMetadata: Get.getForType<Get.valueWithMeta<Js.Json.t, 'm>>
let getAnyWithMetadata: Get.getForType<Get.valueWithMeta<'a, 'm>>
let getArrayBufferWithMetadata: Get.getForType<Get.valueWithMeta<Js.TypedArray2.ArrayBuffer.t, 'm>>
let getStreamWithMetadata: Get.getForType<Get.valueWithMeta<Webapi.ReadableStream.t, 'm>>

let putText: Put.put<string>
let putArrayBuffer: Put.put<Js.TypedArray2.ArrayBuffer.t>
let putDataView: Put.put<Js.TypedArray2.DataView.t>
let putStream: Put.put<Webapi.ReadableStream.t>

let delete: (~namespace: t, ~key: string, unit) => Js.Promise.t<unit>

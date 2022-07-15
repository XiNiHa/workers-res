import type { Miniflare } from "miniflare";

type KVNamespace = Awaited<ReturnType<Miniflare['getKVNamespace']>>
type KVPutValueType = Parameters<KVNamespace['put']>[1]

export default async (
  namespace: KVNamespace,
  values: ([string, KVPutValueType] | [string, KVPutValueType, any])[]
) => {
  for (const [key, value, metadata] of values) {
    await namespace.put(key, value, { metadata });
  }
};

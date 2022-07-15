import { dirname } from "node:path";
import { fileURLToPath } from "node:url";
import { beforeEach, describe, it, expect } from "vitest";
import { Miniflare } from "miniflare";
import prepareWorker from "../__utils__/prepareWorker.js";

const __dirname = dirname(fileURLToPath(import.meta.url));

describe("KV put", () => {
  let miniflare: Miniflare;

  beforeEach(async () => {
    miniflare = await prepareWorker(__dirname, "Test__KV_Put", {
      kvNamespaces: ["kv"],
    });
  });

  it("successfully adds an item", async () => {
    const res = await miniflare.dispatchFetch("http://localhost:8787", {
      method: "POST",
      body: JSON.stringify({ key: "foo", value: "bar" }),
    });

    expect(res.ok).toBe(true);
    expect(
      await miniflare.getKVNamespace("kv").then((ns) => ns.get("foo"))
    ).toBe("bar");
  });

  it("successfully adds an item with metadata", async () => {
    const res = await miniflare.dispatchFetch("http://localhost:8787", {
      method: "POST",
      body: JSON.stringify({
        key: "foo",
        value: "bar",
        metadata: { myMeta: "language?" },
      }),
    });

    expect(res.ok).toBe(true);
    expect(
      await miniflare
        .getKVNamespace("kv")
        .then((ns) => ns.getWithMetadata("foo"))
    ).toMatchObject({
      value: "bar",
      metadata: { myMeta: "language?" },
    });
  });
});

import { dirname } from "node:path";
import { fileURLToPath } from "node:url";
import { beforeEach, describe, it, expect } from "vitest";
import { Miniflare } from "miniflare";
import prepareWorker from "../__utils__/prepareWorker.js";
import prepareKv from "../__utils__/prepareKv.js";

const __dirname = dirname(fileURLToPath(import.meta.url));

describe("KV delete", () => {
  let miniflare: Miniflare;

  beforeEach(async () => {
    miniflare = await prepareWorker(__dirname, "Test__KV_Delete", {
      kvNamespaces: ["kv"],
    });
  });

  it("successfully deletes an item", async () => {
    await prepareKv(await miniflare.getKVNamespace("kv"), [["foo", "bar"]]);

    const res = await miniflare.dispatchFetch("http://localhost:8787?key=foo");

    expect(res.ok).toBe(true);
    expect(
      await miniflare.getKVNamespace("kv").then((ns) => ns.get("foo"))
    ).toBe(null);
  });
});

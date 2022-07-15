import { dirname } from "node:path";
import { fileURLToPath } from "node:url";
import { beforeEach, describe, it, expect } from "vitest";
import { Miniflare } from "miniflare";
import prepareWorker from "../__utils__/prepareWorker.js";
import prepareKv from "../__utils__/prepareKv.js";

const __dirname = dirname(fileURLToPath(import.meta.url));

describe("KV list", () => {
  let miniflare: Miniflare;

  beforeEach(async () => {
    miniflare = await prepareWorker(__dirname, "Test__KV_List", {
      kvNamespaces: ["kv"],
    });
  });

  it("returns empty result by default", async () => {
    const res = await miniflare.dispatchFetch("http://localhost:8787");
    const { value }: any = await res.json();
    expect(value.keys).toMatchObject([]);
    expect(value.list_complete).toBe(true);
    expect(typeof value.cursor).toBe("string");
  });

  it("returns correct items when KV has items", async () => {
    await prepareKv(await miniflare.getKVNamespace("kv"), [["foo", "bar"]]);

    const res = await miniflare.dispatchFetch("http://localhost:8787");
    const { value }: any = await res.json();
    expect(value.keys).toMatchObject([{ name: "foo" }]);
    expect(value.list_complete).toBe(true);
    expect(typeof value.cursor).toBe("string");
  });

  it("correctly applies the 'prefix' option", async () => {
    await prepareKv(await miniflare.getKVNamespace("kv"), [
      ["foo", "bar"],
      ["a-foo", "a-bar"],
    ]);

    const res = await miniflare.dispatchFetch(
      "http://localhost:8787?prefix=a-"
    );
    const { value }: any = await res.json();
    expect(value.keys).toMatchObject([{ name: "a-foo" }]);
    expect(value.list_complete).toBe(true);
    expect(typeof value.cursor).toBe("string");
  });

  it("correctly applies the 'limit' option", async () => {
    await prepareKv(
      await miniflare.getKVNamespace("kv"),
      new Array(10).fill(0).map((_, i) => [`foo${i}`, `bar${i}`])
    );

    const res = await miniflare.dispatchFetch(
      "http://localhost:8787?limit=4"
    );
    const { value }: any = await res.json();
    expect(value.keys).toMatchObject([
      { name: "foo0" },
      { name: "foo1" },
      { name: "foo2" },
      { name: "foo3" },
    ]);
    expect(value.list_complete).toBe(false);
    expect(typeof value.cursor).toBe("string");
  });

  it("correctly applies the 'cursor' option", async () => {
    const ns = await miniflare.getKVNamespace("kv");
    await prepareKv(
      ns,
      new Array(10).fill(0).map((_, i) => [`foo${i}`, `bar${i}`])
    );

    const initialResult = await ns.list({ limit: 8 });
    const cursor = initialResult.cursor;

    const res = await miniflare.dispatchFetch(
      `http://localhost:8787?cursor=${cursor}`
    );
    const { value }: any = await res.json();
    expect(value.keys).toMatchObject([{ name: "foo8" }, { name: "foo9" }]);
    expect(value.list_complete).toBe(true);
    expect(typeof value.cursor).toBe("string");
  });
});

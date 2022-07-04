import { dirname } from "node:path";
import { fileURLToPath } from "node:url";
import { beforeEach, describe, it, expect } from "vitest";
import { Miniflare } from "miniflare";
import prepareWorker from "./__utils__/prepareWorker.js";

const __dirname = dirname(fileURLToPath(import.meta.url));

describe("KV", () => {
  let miniflare: Miniflare;

  beforeEach(async () => {
    miniflare = await prepareWorker(__dirname, "Test__Kv", {
      kvNamespaces: ["kv"],
    });
  });

  it("/list returns empty result by default", async () => {
    const res = await miniflare.dispatchFetch("http://localhost:8787/list");
    const { value }: any = await res.json();
    expect(value.keys).toMatchObject([]);
    expect(value.list_complete).toBe(true);
    expect(typeof value.cursor).toBe("string");
  });

  it("/getJson returns null for unknown key", async () => {
    const res = await miniflare.dispatchFetch("http://localhost:8787/getJson?key=foobar");
    expect(await res.json()).toMatchObject({ value: null })
  });
});

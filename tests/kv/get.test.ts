import { dirname } from "node:path";
import { fileURLToPath } from "node:url";
import { beforeEach, describe, it, expect } from "vitest";
import { Miniflare } from "miniflare";
import prepareWorker from "../__utils__/prepareWorker.js";
import prepareKv from "../__utils__/prepareKv.js";

const __dirname = dirname(fileURLToPath(import.meta.url));

describe("KV get", () => {
  let miniflare: Miniflare;

  beforeEach(async () => {
    miniflare = await prepareWorker(__dirname, "Test__KV_Get", {
      kvNamespaces: ["kv"],
    });
  });

  it("returns null for unknown key", async () => {
    const res = await miniflare.dispatchFetch(
      "http://localhost:8787?key=foobar"
    );
    expect(await res.json()).toMatchObject({ value: null });
  });

  it("returns valid JSON data for known key", async () => {
    await prepareKv(await miniflare.getKVNamespace("kv"), [
      ["foo", `{"message":"bar"}`],
    ]);

    const res = await miniflare.dispatchFetch("http://localhost:8787?key=foo");
    expect(await res.json()).toMatchObject({ value: { message: "bar" } });
  });

  it("returns valid text for known key with 'type' set to 'text'", async () => {
    await prepareKv(await miniflare.getKVNamespace("kv"), [["foo", "bar"]]);

    const res = await miniflare.dispatchFetch(
      "http://localhost:8787?key=foo&type=text"
    );
    expect(await res.text()).toBe("bar");
  });

  it("returns valid stream for known key with 'type' set to 'stream'", async () => {
    await prepareKv(await miniflare.getKVNamespace("kv"), [["foo", "bar"]]);

    const res = await miniflare.dispatchFetch(
      "http://localhost:8787?key=foo&type=stream"
    );
    // TODO: is there any good way to test that the returned data was actually a stream?
    expect(await res.text()).toBe("bar");
  });

  it("returns valid JSON data and metadata for known key with 'meta' set to true", async () => {
    await prepareKv(await miniflare.getKVNamespace("kv"), [
      ["foo", `{"message":"bar"}`, { myMeta: "language?" }],
    ]);

    const res = await miniflare.dispatchFetch(
      "http://localhost:8787?key=foo&meta=true"
    );
    expect(await res.json()).toMatchObject({
      value: {
        value: { message: "bar" },
        metadata: { myMeta: "language?" },
      },
    });
  });

  it("returns valid text and metadata for known key with 'type' set to 'text', 'meta' set to true", async () => {
    await prepareKv(await miniflare.getKVNamespace("kv"), [
      ["foo", "bar", { myMeta: "language?" }],
    ]);

    const res = await miniflare.dispatchFetch(
      "http://localhost:8787?key=foo&type=text&meta=true"
    );
    expect(await res.json()).toMatchObject({
      value: {
        value: "bar",
        metadata: { myMeta: "language?" },
      },
    });
  });

  // TODO: add cacheTtl option test?
});

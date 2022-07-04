import { dirname } from "node:path";
import { fileURLToPath } from 'node:url'
import { beforeEach, describe, it, expect } from "vitest";
import { Miniflare } from "miniflare";
import prepareWorker from "./__utils__/prepareWorker.js";

const __dirname = dirname(fileURLToPath(import.meta.url));

describe("basic", () => {
  let miniflare: Miniflare;

  beforeEach(async () => {
    miniflare = await prepareWorker(__dirname, 'Test__Basic')
  });

  it("returns 'Hello world!'", async () => {
    const res = await miniflare.dispatchFetch("http://localhost:8787");
    expect(await res.text()).toBe("Hello world!");
  });
});

import { dirname } from "node:path";
import { fileURLToPath } from "node:url";
import { beforeEach, describe, it, expect } from "vitest";
import { Miniflare } from "miniflare";
import prepareWorker from "./__utils__/prepareWorker.js";

const __dirname = dirname(fileURLToPath(import.meta.url));

describe("scheduled event", () => {
  let miniflare: Miniflare;

  beforeEach(async () => {
    miniflare = await prepareWorker(__dirname, "Test__Scheduled");
  });

  it("counter increases per every scheduled invocation", async () => {
    for (let i = 0; i < 5; i++) {
      const res = await miniflare.dispatchFetch("http://localhost:8787");
      const counter = await res.text()
      expect(counter).toBe(i.toString());
      await miniflare.dispatchScheduled()
    }
  });
});

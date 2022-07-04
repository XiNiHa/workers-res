import { dirname } from "node:path";
import { fileURLToPath } from 'node:url'
import { beforeEach, describe, it, expect } from "vitest";
import { Miniflare } from "miniflare";
import prepareWorker from "./__utils__/prepareWorker.js";

const __dirname = dirname(fileURLToPath(import.meta.url));

describe("env bindings usage", () => {
  let miniflare: Miniflare;

  beforeEach(async () => {
    miniflare = await prepareWorker(__dirname, 'Test__Env', { bindings: { theAnswer: 42 } })
  });

  it("returns 'The answer is: 42'", async () => {
    const res = await miniflare.dispatchFetch("http://localhost:8787");
    expect(await res.text()).toBe("The answer is: 42");
  });
});

import { join } from "node:path";
import { buildWorker } from "build-worker";
import { Miniflare, MiniflareOptions } from "miniflare";

export default async (dirname: string, moduleName: string, options?: MiniflareOptions) => {
  await buildWorker({
    entry: join(dirname, `${moduleName}.bs.js`),
    out: join(dirname, `dist/${moduleName}.mjs`),
  })
  return new Miniflare({
    modules: true,
    scriptPath: join(dirname, `dist/${moduleName}.mjs`),
    buildCommand: undefined,
    ...options,
  });
}

#!/usr/bin/env -S deno run
import { Command } from "./deps/cliffy.ts";
import packageJson from "../package.json" with { type: "json" };

await new Command()
  .name("play")
  .version(packageJson.version)
  .versionOption("-v, --version")
  .action(() => {
    console.log("Play!!!");
  })
  .parse();

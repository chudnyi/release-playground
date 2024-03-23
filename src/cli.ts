#!/usr/bin/env -S deno run
import { Command } from "./deps/cliffy.ts";

await new Command()
  .name("play")
  .action(() => {
    console.log("Play!!!");
  })
  .parse();

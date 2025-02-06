```
ao publish -w ~/.wallet.json process.wasm \
  -t Memory-Limit -v 1-gb \
  -t Compute-Limit -v 9000000000000 \
  -t Module-Format -v wasm64-unknown-emscripten-draft_2024_02_15 \
  -t AOS-Version -v 2.0.1 \
  -t Name -v aos-hello-vg-0.0.1
```

# third-party-apis-google

Synced subset of [Google API definitions](https://github.com/googleapis/googleapis) for use with the [APX](https://github.com/infobloxopen/apx) catalog system.

## What's included

- `google/api/` — Core Google API annotations (HTTP, field behavior, resource)
- `google/rpc/` — gRPC status and error model

## How it works

1. Proto files are synced from upstream `googleapis/googleapis`
2. Release tags follow the APX convention: `proto/google/<name>/v1/v<semver>`
3. The `infobloxopen/apis` repo references this repo via `api_sources` in `apx.yaml`
4. `apx catalog generate` fetches tags from this repo and includes them in the catalog
5. Import paths are **preserved** — consumers use `google/api/annotations.proto` as-is

## Syncing from upstream

```bash
./scripts/sync.sh
```

## Tagging a release

```bash
git tag proto/google/api/v1/v1.0.0
git tag proto/google/rpc/v1/v1.0.0
git push origin --tags
```

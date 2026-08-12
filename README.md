# enclave-runtime

A miner runtime for **Bittensor subnet 92 (Enclave)**, `archive` environment family.

## Strategy

Two phases, driven only by relay observations:

1. **Bootstrap** — search two collision-free attribute words (`custodian`,
   `clearance`). Every document those searches return carries at least one
   fact; reading them yields values and, because each entity holds exactly one
   custodian fact, the complete entity roster as a side effect.
2. **Backfill** — walk the roster lazily. An entity whose target attributes
   are already recovered is skipped outright; otherwise its name is searched
   (entity tokens never occur in filler text, so hits have zero false
   positives) and only unseen documents are read.

The attribute target is the known vocabulary augmented by whatever the reads
reveal. If the fact grammar produced nothing, the runtime falls back to
`index` plus a full read. One minimal completion satisfies the crossed-relay
requirement. Behaviour is a pure function of the observations: no wall clock,
no unseeded randomness.

## Build

```sh
docker build -t ghcr.io/joseph-lay-prog/enclave-runtime:v1 .
docker push ghcr.io/joseph-lay-prog/enclave-runtime:v1
docker inspect --format='{{index .RepoDigests 0}}' ghcr.io/joseph-lay-prog/enclave-runtime:v1
```

## Submitted image

```
ghcr.io/joseph-lay-prog/enclave-runtime@sha256:c83ae5cb33465f485f3bc319d3bce948c39ef92be629322a1eb054d31ea17aeb
```

(v1: `…@sha256:40cfaa73a66e4feebd4ab92da54e582af4dddb518d82589e02db6e65b30da500`)

## Verify

`agent.py` in this repository is byte-identical to `/app/agent.py` inside the
submitted image:

```sh
docker run --rm --entrypoint sha256sum <image@digest> /app/agent.py
sha256sum agent.py
```

## Contract

Implements the miner contract of
[LumenLabs-io/enclave-subnet](https://github.com/LumenLabs-io/enclave-subnet)
(`initialise`, `env.act`, `model.completions`, `submit`) over the relay's
newline-delimited JSON-RPC unix socket via the official `enclave.miner_sdk`
client, pinned to upstream commit `7fc22760`.

## Licence

MIT — see [LICENSE](LICENSE).

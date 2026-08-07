# Atlas Core Migration Plan

Status: Active

---

## Goal

Migrate Atlas from the legacy RepositoryScanner architecture to the new
RepositoryModel / RepositorySnapshot architecture incrementally.

No big-bang rewrite.

---

## Principles

- One capability at a time.
- One file per commit whenever possible.
- Keep main green.
- Remove legacy only after migration is complete.

---

## Completed

- [x] RepositoryModel
- [x] RepositorySnapshot
- [x] RepositorySnapshotBuilder
- [x] New RepositoryScanner

---

## In Progress

- [ ] Doctor

---

## Planned

- [ ] Inventory
- [ ] Graph
- [ ] Repository statistics

---

## Legacy

- [ ] ExecutiveService
- [ ] Legacy RepositoryScanner

Legacy components are removed only when no production code depends on them.


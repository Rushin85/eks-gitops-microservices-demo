# Demo Steps (Draft)
1) Show app reachable via ingress
2) Commit change -> Argo CD sync (dev)
3) Load test -> HPA scales pods
4) Cluster Autoscaler adds nodes (if needed)
5) Promote dev -> prod and sync
6) Optional rollback demo

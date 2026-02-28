# Demo Steps (Draft)
1) Show app reachable via ingress
2) Commit change -> Argo CD sync (dev)
3) Load test -> HPA scales pods
4) Cluster Autoscaler adds nodes (if needed)
5) Promote dev -> prod and sync
6) Optional rollback demo

“Show Argo app Synced/Healthy”
“Commit change (replicas) → Argo OutOfSync → Sync → rollout”
“Rollback via git revert”
“HPA demo commands” (even if you run it later)

# Demo Steps – EKS + Helm + Argo CD GitOps (Online Boutique)

> Goal: Demonstrate GitOps deployment and scaling under load for Online Boutique on AWS EKS.
> Repo structure: terraform/, helm/, gitops/, docs/

---

## 0) Pre-demo safety checks (READ-ONLY)
These commands do not modify the cluster.

```bash
kubectl get nodes
kubectl get ns
kubectl get applications -n argocd
kubectl get pods -n argocd
kubectl get pods -n dev
kubectl get svc -n dev
kubectl get ingress -n dev || true
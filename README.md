# Kubernetes Secret Patcher

Store passwords from .env file into a secret in Kubernetes

Create .env file with variables.

```batch
sh secrets.sh <secret name> <namespace>

# example
sh secrets.sh argocd-secret argocd
```

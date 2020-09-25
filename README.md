# Kubernetes Secret Patcher

Store passwords from .env file into a secret in Kubernetes

Create .env file with variables.

```batch
sh secrets.sh <file> <secret name> <namespace>

# example
sh secrets.sh argocd.env argocd-secret argocd
```

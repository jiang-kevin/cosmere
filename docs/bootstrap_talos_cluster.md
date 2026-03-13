1. Create cluster infrastructure through OpenTofu:

```sh
tofu plan
tofu apply
```

2. Log in to Proxmox UI, and validate the VMs started up successfully and have the correct IP addresses.
3. Run the Talos bootstrap cluster shell script:

```sh
kube/bootstrap/shadesmar/bootstrap-talos.sh
```

4. After the VMs restart, run `talosctl bootstrap`

```sh
talosctl bootstrap
```

5. Apply Gateway API CRDs:

```sh
kubectl apply --server-side -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.5.0/experimental-install.yaml
```

6. Install Cilium

```sh
cilium install -f kube/bootstrap/shadesmar/cilium-values.yaml
```
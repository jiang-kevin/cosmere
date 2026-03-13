CONTROL_PLANE_IP="192.168.17.160"
WORKER_IP="192.168.17.161"
CLUSTER_NAME="shadesmar"
DISK_NAME="vda"

talosctl gen config $CLUSTER_NAME https://$CONTROL_PLANE_IP:6443 --config-patch @talos-patch.yaml --output-dir .talos --install-disk /dev/$DISK_NAME --install-image factory.talos.dev/nocloud-installer/de1b2ac5fa6eefcc038cfc1313c553c460d21c10306ced434f48f30ae05c0905:v1.12.5

talosctl apply-config --insecure --nodes $CONTROL_PLANE_IP --file .talos/controlplane.yaml
echo "Applied controlplane machine config"

talosctl apply-config --insecure --nodes $WORKER_IP --file .talos/worker.yaml
echo "Applied worker machine config"

talosctl --talosconfig=.talos/talosconfig config endpoints $CONTROL_PLANE_IP
talosctl --talosconfig=.talos/talosconfig config nodes $CONTROL_PLANE_IP

cp .talos/talosconfig $HOME/.talos/config
module "cluster" {
    source = "../cluster"

    name = var.name
    cluster_id = var.cluster_id
    cephfs_datastore_id = "CephFS"
    cephrbd_datastore_id = "RBD_Common"
    domain = "etsmtl.club"
    proxmox_base_id = 1000000

    talos_image_id = "iso/metal-amd64-omni-cedille-v1.8.0-2.iso"

    network_config = {
        internal_vlan_id = 21
        external_vlan_id = 247
        common_cidr = 16
        cluster_cidr = 25
        interface = "vmbr1"
        common_subnet = "10.10.0.0"
    }

    public_ip = var.public_ip

    controlplanes = var.controlplanes
    workers = var.workers

    talos_version = "v1.8.0"
    k8s_version = "v1.30.0"

    owner_tag = var.owner_tag
    environment_tag = var.environment_tag

    onboard_argocd = var.onboard_argocd

    omni_url = "https://cedille.kubernetes.omni.siderolabs.io"
}

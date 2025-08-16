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
        internal_vlan_id = 500
        external_vlan_id = 247
        cluster_vlan_id = 1000 + var.cluster_id
        interface = "vmbr1"
        internal_subnet = "10.5.0.0/24"
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

    switch_url = var.switch_url
    switch_username = var.switch_username
    switch_password = var.switch_password
}

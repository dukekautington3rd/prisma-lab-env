resource "kubernetes_namespace" "twistlock" {
  metadata {
    name = "twistlock"
  }
}


resource "kubernetes_cluster_role" "twistlock_view" {
  metadata {
    name = "twistlock-view"
  }

  rule {
    verbs      = ["list"]
    api_groups = ["rbac.authorization.k8s.io"]
    resources  = ["roles", "rolebindings", "clusterroles", "clusterrolebindings"]
  }

  rule {
    verbs      = ["get"]
    api_groups = ["apps"]
    resources  = ["deployments", "replicasets"]
  }

  rule {
    verbs      = ["get"]
    api_groups = [""]
    resources  = ["namespaces", "pods"]
  }
}

resource "kubernetes_cluster_role_binding" "twistlock_view_binding" {
  metadata {
    name = "twistlock-view-binding"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "twistlock-service"
    namespace = "twistlock"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "twistlock-view"
  }
}

resource "kubernetes_secret" "twistlock_secrets" {
  metadata {
    name      = "twistlock-secrets"
    namespace = "twistlock"
  }

  data = {
    "admission-cert.pem" = var.PCC_ADMISSION_CERT

    "admission-key.pem" = var.PCC_ADMISSION_KEY

    "defender-ca.pem" = var.PCC_DEFENDER_CA

    "defender-client-cert.pem" = var.PCC_DEFENDER_CLIENT_CERT

    "defender-client-key.pem" = var.PCC_DEFENDER_CLIENT_KEY

    "service-parameter" = var.PCC_SERVICE_PARAMETER
  }

  type = "Opaque"
}

resource "kubernetes_service_account" "twistlock_service" {
  metadata {
    name      = "twistlock-service"
    namespace = "twistlock"
  }

  secret {
    name = "twistlock-secrets"
  }
}

resource "kubernetes_daemonset" "twistlock_defender_ds" {
  metadata {
    name      = "twistlock-defender-ds"
    namespace = "twistlock"
  }

  spec {
    selector {
      match_labels = {
        app = "twistlock-defender"
      }
    }

    template {
      metadata {
        labels = {
          app = "twistlock-defender"
        }

        annotations = {
          "container.apparmor.security.beta.kubernetes.io/twistlock-defender" = "unconfined"
        }
      }

      spec {
        volume {
          name = "certificates"

          secret {
            secret_name  = "twistlock-secrets"
            default_mode = "0400"
          }
        }

        volume {
          name = "syslog-socket"

          host_path {
            path = "/dev/log"
          }
        }

        volume {
          name = "data-folder"

          host_path {
            path = "/var/lib/twistlock"
          }
        }

        volume {
          name = "passwd"

          host_path {
            path = "/etc/passwd"
          }
        }

        volume {
          name = "docker-sock-folder"

          host_path {
            path = "/var/run"
          }
        }

        container {
          name  = "twistlock-defender"
          image = var.PCC_IMAGE

          env {
            name  = "WS_ADDRESS"
            value = var.PCC_WS_ADDRESS
          }

          env {
            name  = "DEFENDER_TYPE"
            value = "daemonset"
          }

          env {
            name  = "DEFENDER_LISTENER_TYPE"
            value = "none"
          }

          env {
            name  = "LOG_PROD"
            value = "true"
          }

          env {
            name  = "SYSTEMD_ENABLED"
            value = "false"
          }

          env {
            name  = "DOCKER_CLIENT_ADDRESS"
            value = "/var/run/docker.sock"
          }

          env {
            name  = "DEFENDER_CLUSTER_ID"
            value = "da4ff95e-357a-e6c5-359f-5f62ae968d1e"
          }

          env {
            name = "DEFENDER_CLUSTER"
          }

          env {
            name  = "MONITOR_SERVICE_ACCOUNTS"
            value = "true"
          }

          env {
            name  = "MONITOR_ISTIO"
            value = "false"
          }

          env {
            name  = "COLLECT_POD_LABELS"
            value = "true"
          }

          env {
            name  = "INSTALL_BUNDLE"
            value = var.PCC_INSTALL_BUNDLE
          }

          env {
            name  = "HOST_CUSTOM_COMPLIANCE_ENABLED"
            value = "true"
          }

          env {
            name  = "CLOUD_HOSTNAME_ENABLED"
            value = "false"
          }

          resources {
            limits = {
              cpu = "900m"

              memory = "512Mi"
            }

            requests = {
              cpu = "256m"
            }
          }

          volume_mount {
            name       = "data-folder"
            mount_path = "/var/lib/twistlock"
          }

          volume_mount {
            name       = "certificates"
            mount_path = "/var/lib/twistlock/certificates"
          }

          volume_mount {
            name       = "docker-sock-folder"
            mount_path = "/var/run"
          }

          volume_mount {
            name       = "passwd"
            read_only  = true
            mount_path = "/etc/passwd"
          }

          volume_mount {
            name       = "syslog-socket"
            mount_path = "/dev/log"
          }

          security_context {
            capabilities {
              add = ["NET_ADMIN", "NET_RAW", "SYS_ADMIN", "SYS_PTRACE", "SYS_CHROOT", "MKNOD", "SETFCAP", "IPC_LOCK"]
            }

            read_only_root_filesystem = true
          }
        }

        restart_policy       = "Always"
        dns_policy           = "ClusterFirstWithHostNet"
        service_account_name = "twistlock-service"
        host_network         = true
        host_pid             = true
      }
    }
  }
}

resource "kubernetes_service" "defender" {
  metadata {
    name      = "defender"
    namespace = "twistlock"

    labels = {
      app = "twistlock-defender"
    }
  }

  spec {
    port {
      port        = 443
      target_port = "9998"
    }

    selector = {
      app = "twistlock-defender"
    }
  }
}
/*
resource "kubernetes_validating_webhook_configuration" "tw_validating_webhook" {
  metadata {
    name = "tw-validating-webhook"
  }

  webhook {
    name = "validating-webhook.twistlock.com"

    client_config {
      service {
        namespace = "twistlock"
        name      = "defender"
        path      = "/bssapd2ho7qjlk6rate5arthrg4z"
      }

      ca_bundle = var.PCC_VWH_CA
    }

    rule {
      operations = ["CREATE", "UPDATE", "CONNECT"]
    }

    failure_policy            = "Ignore"
    match_policy              = "Equivalent"
    side_effects              = "None"
    timeout_seconds           = 2
    admission_review_versions = ["v1", "v1beta1"]
  }
}
*/

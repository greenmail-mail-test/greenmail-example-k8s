// ### Terraform ###

terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.8.0"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}


// ### Namespace ###

resource "kubernetes_namespace" "greenmail" {
  metadata {
    name = "tf-ns-greenmail"
  }
}


// ### GreenMail POD ###

resource "kubernetes_pod" "greenmail" {
  metadata {
    name = "tf-pod-greenmail"
    namespace = kubernetes_namespace.greenmail.metadata.0.name
    labels = {
      "app.kubernetes.io/name" = "greenmail"
      "app.kubernetes.io/instance" = "greenmail-k8s-example"
      "app.kubernetes.io/version" = "1.6.7"
      "app.kubernetes.io/component" = "mailserver"
      "app.kubernetes.io/part-of" = "greenmail-k8s-example"
      "app.kubernetes.io/managed-by" = "terraform"
      "app.kubernetes.io/created-by" = "mm"
    }
  }
  spec {
     container {
       name  = "greenmail-container"
       image = "greenmail/standalone:1.6.7"
       image_pull_policy = "IfNotPresent"
       port {
         name = "smtp"
         container_port = 3025
       }
       port {
         name = "pop3"
         container_port = 3110
       }
       port {
         name = "imap"
         container_port = 3143
       }
       port {
         name = "smtps"
         container_port = 3465
       }
       port {
         name = "imaps"
         container_port = 3993
       }
       port {
         name = "pop3s"
         container_port = 3995
       }
       port {
         name = "api"
         container_port = 8080
       }
       env {
         name = "GREENMAIL_OPTS"
         value = "-Dgreenmail.setup.test.all -Dgreenmail.hostname=0.0.0.0 -Dgreenmail.auth.disabled -Dgreenmail.verbose"
       }
       env {
         name = "JAVA_OPTS"
         value = ""
       }
       readiness_probe {
         http_get {
           port = 8080
           path = "/api/service/readiness"
         }
         initial_delay_seconds = 5
         period_seconds = 2
       }
     }
  } // spec
}


// ### Services ####

resource "kubernetes_service" "greenmail-service" {
  metadata {
    name      = "tf-service-greenmail-service"
    namespace = kubernetes_namespace.greenmail.metadata.0.name
  }
  spec {
    selector = {
      "app.kubernetes.io/name" = "greenmail"
      "app.kubernetes.io/instance" = "greenmail-k8s-example"
      "app.kubernetes.io/version" = "1.6.7"
      "app.kubernetes.io/component" = "mailserver"
      "app.kubernetes.io/part-of" = "greenmail-k8s-example"
      "app.kubernetes.io/managed-by" = "terraform"
      "app.kubernetes.io/created-by" = "mm"
    }
    type = "NodePort"
    port {
      name        = "smtp"
      protocol    = "TCP"
      port        = 3025
      target_port = 3025
      node_port   = 3025
    }
    port {
      name        = "pop3"
      protocol    = "TCP"
      port        = 3110
      target_port = 3110
      node_port   = 3110
    }
    port {
      name        = "imap"
      protocol    = "TCP"
      port        = 3143
      target_port = 3143
      node_port   = 3143
    }
    port {
      name        = "smtps"
      protocol    = "TCP"
      port        = 3465
      target_port = 3465
      node_port   = 3465
    }
    port {
      name        = "imaps"
      protocol    = "TCP"
      port        = 3993
      target_port = 3993
      node_port   = 3993
    }
    port {
      name        = "pop3s"
      protocol    = "TCP"
      port        = 3995
      target_port = 3995
      node_port   = 3995
    }
    port {
      name        = "api"
      protocol    = "TCP"
      port        = 8080
      target_port = 8080
      node_port   = 8080
    }
  }
}

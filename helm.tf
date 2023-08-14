resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress-controller"

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace        = "ingress-nginx" 
  create_namespace = true #creates the namespace for me if not exist so I don't need to create it by myself

  set {
    name  = "service.type"
    value = "ClusterIP"
  }
}

resource "helm_release" "argo-cd_chart" {
  name       = "argo-cd"

  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argo" 
  version          = "5.26.0"
  create_namespace = true #creates the namespace for me if not exist so I don't need to create it by myself

  set {
    name  = "configs.params.server\\.insecure"
    value = "true"
  }
  set {
     name  = "server.ingress.enabled"
     value = "true"
  }
  set {
     name  = "server.ingress.hosts.host"
     value = "argo123.duckdns.org"
  }
  set {
     name  = "server.ingress.ingressClassName"
     value = "nginx"
  }
  #set {
  #   name  = "server.ingress.annotations.nginx\\.ingress\\.kubernetes\\.io/rewrite-target"
  #   value = "/$1"
  #}
  set {
    name  = "crds.keep"
    value = "false"
  }
}

resource "null_resource" "post_install" {
  depends_on = [
    helm_release.argo-cd_chart
  ]

  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --region eu-west-3 --name talk; kubectl -n argo get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d"
    when    = create
  }
}

# Helm Chart: app-template-nestjs

Este chart despliega una aplicación **NestJS** junto con **MongoDB** en Kubernetes, evitando duplicación de manifiestos mediante plantillas Helm.

## Requisitos
- Kubernetes >= 1.22
- Helm >= 3.11
- Imagen container de la app construida y disponible en un registry al que el cluster tenga acceso.

## Estructura
```
app-template-nestjs-chart/
├─ Chart.yaml
├─ values.yaml
├─ .helmignore
├─ templates/
│  ├─ _helpers.tpl
│  ├─ deployment.yaml          # App NestJS
│  ├─ service.yaml             # Service de la app
│  ├─ ingress.yaml             # (opcional)
│  ├─ mongodb-statefulset.yaml # MongoDB con PVC
│  ├─ mongodb-service.yaml
│  ├─ mongodb-headless.yaml
│  ├─ mongodb-secret.yaml      # (si auth.enabled)
│  ├─ tests/test-connection.yaml
│  └─ NOTES.txt
├─ scripts/
│  └─ test.sh
└─ evidencia/
```

## Instalación rápida
```bash
helm upgrade --install my-app ./ -n my-app --create-namespace
kubectl get pods,svc -n my-app -l app.kubernetes.io/instance=my-app
kubectl -n my-app port-forward svc/my-app-app-template-nestjs 8080:3000
curl -sf http://localhost:8080/health
```

## Pruebas con Helm test
```bash
helm test my-app -n my-app
```

## Desinstalación
```bash
helm uninstall my-app -n my-app
```

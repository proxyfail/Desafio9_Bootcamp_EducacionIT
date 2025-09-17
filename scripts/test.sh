#!/usr/bin/env bash
set -euo pipefail

RELEASE_NAME=${1:-my-app}
NAMESPACE=${2:-my-app}
CHART_DIR=${3:-$(cd "$(dirname "$0")/.." && pwd)}

bold() { echo -e "[1m$*[0m"; }
ok() { echo -e "[[32mOK[0m] $*"; }
err() { echo -e "[[31mERR[0m] $*"; }

bold "Instalando/Actualizando release: $RELEASE_NAME en ns: $NAMESPACE"
helm upgrade --install "$RELEASE_NAME" "$CHART_DIR" -n "$NAMESPACE" --create-namespace

bold "Esperando pods..."
kubectl -n "$NAMESPACE" wait --for=condition=Available deploy -l app.kubernetes.io/instance="$RELEASE_NAME" --timeout=180s || true

bold "Listando recursos"
kubectl -n "$NAMESPACE" get pods,svc -l app.kubernetes.io/instance="$RELEASE_NAME"

bold "Probing /health via port-forward"
set +e
kubectl -n "$NAMESPACE" port-forward svc/${RELEASE_NAME}-app-template-nestjs 18080:3000 >/dev/null 2>&1 &
PF_PID=$!
sleep 2
curl -sf "http://localhost:18080/health" && ok "Health endpoint responde" || err "No respondió /health"
kill $PF_PID >/dev/null 2>&1 || true
set -e

bold "helm test"
helm test "$RELEASE_NAME" -n "$NAMESPACE" || true

bold "Fin"

#!/usr/bin/env bash
# validate-ingress.sh — external smoke test for the EKS ingress endpoint.
#
# Usage:
#   ./scripts/validate-ingress.sh dev.example.com
#   ./scripts/validate-ingress.sh dev.example.com --skip-dns
#
# Prerequisites: curl, kubectl (in PATH), and a valid kubeconfig pointing at
# the target cluster.
set -euo pipefail

INGRESS_HOST="${1:-}"
SKIP_DNS=false
[[ "${2:-}" == "--skip-dns" ]] && SKIP_DNS=true

if [[ -z "${INGRESS_HOST}" ]]; then
  echo "Usage: $0 <hostname> [--skip-dns]"
  exit 1
fi

PASS=0; FAIL=0
ok()   { echo "  PASS: $*"; (( PASS++ )); }
fail() { echo "  FAIL: $*"; (( FAIL++ )); }
section() { echo ""; echo "=== $* ==="; }

# ---------------------------------------------------------------------------
section "1. DNS resolution"
if [[ "${SKIP_DNS}" == "true" ]]; then
  echo "  Skipped (--skip-dns)"
else
  if host "${INGRESS_HOST}" >/dev/null 2>&1; then
    RESOLVED=$(host "${INGRESS_HOST}" | awk '/has address/ {print $NF; exit}')
    ok "Resolves to ${RESOLVED}"
  else
    fail "${INGRESS_HOST} does not resolve"
  fi
fi

# ---------------------------------------------------------------------------
section "2. HTTP -> HTTPS redirect"
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" \
  --max-time 10 "http://${INGRESS_HOST}/" || echo "000")
if [[ "${HTTP_CODE}" == "301" || "${HTTP_CODE}" == "302" ]]; then
  ok "HTTP ${HTTP_CODE} redirect"
else
  fail "Expected redirect, got HTTP ${HTTP_CODE}"
fi

# ---------------------------------------------------------------------------
section "3. HTTPS response (follow redirects)"
HTTPS_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}|%{ssl_verify_result}" \
  --max-time 15 -L "https://${INGRESS_HOST}/" || echo "000|1")
HTTPS_CODE="${HTTPS_RESPONSE%%|*}"
TLS_RESULT="${HTTPS_RESPONSE##*|}"

if [[ "${HTTPS_CODE}" == "200" ]]; then
  ok "HTTPS 200 OK"
else
  fail "Expected HTTPS 200, got ${HTTPS_CODE}"
fi

# ---------------------------------------------------------------------------
section "4. TLS certificate validity"
if [[ "${TLS_RESULT}" == "0" ]]; then
  ok "Certificate valid"
else
  fail "TLS verification failed (curl ssl_verify_result=${TLS_RESULT})"
fi

# Optional: detailed cert info
CERT_SUBJECT=$(curl -sv --max-time 10 "https://${INGRESS_HOST}/" 2>&1 \
  | grep -i "subject:" | head -1 || echo "  (could not retrieve)")
echo "  Subject: ${CERT_SUBJECT}"

CERT_EXPIRY=$(curl -sv --max-time 10 "https://${INGRESS_HOST}/" 2>&1 \
  | grep -i "expire date:" | head -1 || echo "  (could not retrieve)")
echo "  Expiry:  ${CERT_EXPIRY}"

# ---------------------------------------------------------------------------
section "5. Metrics-server (in-cluster)"
if kubectl top nodes >/dev/null 2>&1; then
  ok "kubectl top nodes works — metrics-server is healthy"
  kubectl top nodes
else
  fail "kubectl top nodes failed — metrics-server may not be ready"
fi

# ---------------------------------------------------------------------------
section "6. Ingress object status"
INGRESS_ADDRESS=$(kubectl get ingress example-app -n dev \
  -o jsonpath='{.status.loadBalancer.ingress[0].hostname}' 2>/dev/null || echo "")
if [[ -n "${INGRESS_ADDRESS}" ]]; then
  ok "ALB hostname: ${INGRESS_ADDRESS}"
else
  fail "Ingress has no ALB hostname yet — controller may still be provisioning"
fi

# ---------------------------------------------------------------------------
section "Summary"
echo "  Passed: ${PASS}"
echo "  Failed: ${FAIL}"
[[ "${FAIL}" -eq 0 ]] && echo "All checks passed." && exit 0
echo "One or more checks failed." && exit 1

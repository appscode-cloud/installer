#!/usr/bin/env bash

# Copyright AppsCode Inc. and Contributors
#
# Licensed under the AppsCode Community License 1.0.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://github.com/appscode/licenses/raw/1.0.0/AppsCode-Community-1.0.0.md
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Writes the credentials the ace chart takes as VALUES (database password, Casdoor client secret, KMS key, NATS identities)
# from the Secrets of the akp-prereqs release, as a values file (JSON, mode 0600). Nothing is printed. Run it on the
# host (kubectl must reach the cluster) after `helm install akp-prereqs`, then:
#
#   helm install ace charts/ace -n akp -f charts/ace/profiles/akp-v2-demo.yaml -f "$OUT"
#
#   NS        namespace of the release, default akp
#   PREREQS   release name of akp-prereqs, default akp-prereqs
#   OUT       the values file, default ~/akp/ace-secrets.values.json

set -euo pipefail

NS=${NS:-akp}
PREREQS=${PREREQS:-akp-prereqs}
OUT=${OUT:-$HOME/akp/ace-secrets.values.json}

umask 077
mkdir -p "$(dirname "$OUT")"
cred=$(kubectl -n "$NS" get secret "$PREREQS-credentials" -o json)
nats=$(kubectl -n "$NS" get secret "$PREREQS-nats-creds" -o json)

CRED="$cred" NATS="$nats" python3 -I - >"$OUT" <<'PY'
import base64, hashlib, json, os

def secret(env):
    d = json.loads(os.environ[env])["data"]
    return lambda k: base64.b64decode(d[k]).decode()

c, n = secret("CRED"), secret("NATS")
out = {
    "global": {"infra": {"kms": {"masterKeyURL": "base64key://" + base64.urlsafe_b64encode(hashlib.sha256(c("kms-master-key").encode()).digest()).decode()}}},
    "settings": {
        "db": {"auth": {"password": c("akp-db-password")}},
        "security": {"oauth2JWTSecret": c("oauth2-jwt-secret"), "csrfSecretKey": c("csrf-secret-key")},
        "iam": {"casdoor": {"clientSecret": c("akp-casdoor-client-secret")}},
        "nats": {
            "operatorCreds": n("Operator.creds"),
            "operatorJwt": n("Operator.jwt"),
            "systemCreds": n("SYS.creds"),
            "systemJwt": n("SYS.jwt"),
            "systemPubKey": n("SYS.pub"),
            "systemUserCreds": n("sys.creds"),
            "adminCreds": n("ADMIN.creds"),
            "adminUserCreds": n("admin.creds"),
        },
    },
    "perses": {"config": {"database": {"sql": {"password": c("akp-db-password")}}}},
    # The NATS server of ace's nats chart, in operator mode: the operator, the system account and its JWT.
    "nats": {"auth": {"enabled": True, "resolver": {
        "type": "full",
        "operator": n("Operator.jwt"),
        "systemAccount": n("SYS.pub"),
        "resolverPreload": {n("SYS.pub"): n("SYS.jwt")},
    }}},
}
print(json.dumps(out))
PY
chmod 600 "$OUT"
echo "wrote $OUT (mode 0600)"

#!/usr/bin/env bash
# Seed MongoDB with minimal demo data for all collections.
# Requires MONGODB_URL and MONGODB_DB to be set in the environment.
# Uses mongoimport with per-collection arrays contained in seed.json.

set -euo pipefail

if [[ -z "${MONGODB_URL:-}" || -z "${MONGODB_DB:-}" ]]; then
  echo "Error: MONGODB_URL and MONGODB_DB must be set in the environment."
  echo "Example:"
  echo "  export MONGODB_URL=\"mongodb://localhost:27017\""
  echo "  export MONGODB_DB=\"resumematch\""
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SEED_FILE="${SCRIPT_DIR}/seed.json"

if [[ ! -f "${SEED_FILE}" ]]; then
  echo "Error: seed.json not found at ${SEED_FILE}"
  exit 1
fi

echo "Seeding MongoDB database '${MONGODB_DB}' at '${MONGODB_URL}'..."

# Import each collection from the top-level arrays in seed.json.
mongoimport --uri "${MONGODB_URL}/${MONGODB_DB}" --collection users --jsonArray --file "${SEED_FILE}" --drop --legacy --query '{users:{$exists:true}}' >/dev/null 2>&1 || true
mongoimport --uri "${MONGODB_URL}/${MONGODB_DB}" --collection users --jsonArray --file <(jq -c '.users' "${SEED_FILE}") --drop

mongoimport --uri "${MONGODB_URL}/${MONGODB_DB}" --collection uploads --jsonArray --file <(jq -c '.uploads' "${SEED_FILE}") --drop
mongoimport --uri "${MONGODB_URL}/${MONGODB_DB}" --collection resumes --jsonArray --file <(jq -c '.resumes' "${SEED_FILE}") --drop
mongoimport --uri "${MONGODB_URL}/${MONGODB_DB}" --collection job_descriptions --jsonArray --file <(jq -c '.job_descriptions' "${SEED_FILE}") --drop
mongoimport --uri "${MONGODB_URL}/${MONGODB_DB}" --collection analyses --jsonArray --file <(jq -c '.analyses' "${SEED_FILE}") --drop
mongoimport --uri "${MONGODB_URL}/${MONGODB_DB}" --collection matches --jsonArray --file <(jq -c '.matches' "${SEED_FILE}") --drop

echo "✓ Seed completed successfully."
echo "Collections imported: users, uploads, resumes, job_descriptions, analyses, matches"

#!/usr/bin/env sh
set -eu

DATA_DIR="/data"
INSTANCE_NAME="docker"
VENV_DIR="${DATA_DIR}/venv"
CONFIG_FILE="${DATA_DIR}/config.json"
RED_CONFIG_DIR="${HOME}/.config/Red-DiscordBot"
RED_CONFIG_LINK="${RED_CONFIG_DIR}/config.json"
VERSION_FILE="${VENV_DIR}/.redbotversion"

mkdir -p "${DATA_DIR}" "${RED_CONFIG_DIR}"

if [ ! -f "${CONFIG_FILE}" ]; then
  cat >"${CONFIG_FILE}" <<'EOF'
{
  "docker": {
    "DATA_PATH": "/data",
    "COG_PATH_APPEND": "cogs",
    "CORE_PATH_APPEND": "core",
    "STORAGE_TYPE": "JSON",
    "STORAGE_DETAILS": {}
  }
}
EOF
fi

ln -sf "${CONFIG_FILE}" "${RED_CONFIG_LINK}"

if [ ! -d "${VENV_DIR}" ]; then
  python -m venv "${VENV_DIR}"
fi

# shellcheck disable=SC1090
. "${VENV_DIR}/bin/activate"

python -m pip install --upgrade --no-cache-dir pip setuptools wheel

REDBOT_PACKAGE="Red-DiscordBot${REDBOT_VERSION:-}"
if [ ! -f "${VERSION_FILE}" ] || [ "$(cat "${VERSION_FILE}")" != "${REDBOT_PACKAGE}" ]; then
  python -m pip install --upgrade --upgrade-strategy eager --no-cache-dir "${REDBOT_PACKAGE}"
  printf '%s' "${REDBOT_PACKAGE}" >"${VERSION_FILE}"
else
  python -m pip install --upgrade --no-cache-dir "${REDBOT_PACKAGE}"
fi

PREFIX_ARGS=""
for var_name in PREFIX PREFIX2 PREFIX3 PREFIX4 PREFIX5; do
  eval "value=\${${var_name}:-}"
  if [ -n "${value}" ]; then
    PREFIX_ARGS="${PREFIX_ARGS} --prefix ${value}"
  fi
done

if [ -n "${OWNER:-}" ]; then
  python -O -m redbot "${INSTANCE_NAME}" --edit --no-prompt --owner "${OWNER}"
fi

if [ -n "${TOKEN:-}" ]; then
  python -O -m redbot "${INSTANCE_NAME}" --edit --no-prompt --token "${TOKEN}"
fi

if [ -n "${PREFIX_ARGS}" ]; then
  # shellcheck disable=SC2086
  python -O -m redbot "${INSTANCE_NAME}" --edit --no-prompt ${PREFIX_ARGS}
fi

# shellcheck disable=SC2086
exec python -O -m redbot "${INSTANCE_NAME}" ${EXTRA_ARGS:-}

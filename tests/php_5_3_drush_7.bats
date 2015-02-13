#!/usr/bin/env bats

FIG_FILE="${BATS_TEST_DIRNAME}/php_5_3_drush_7.yml"

container() {
  echo "$(fig -f ${FIG_FILE} ps php | grep php | awk '{ print $1 }')"
}

setup() {
  fig -f "${FIG_FILE}" up -d

  sleep 10
}

teardown() {
  fig -f "${FIG_FILE}" kill
  fig -f "${FIG_FILE}" rm --force
}

@test "PHP 5.3: Drush 7" {
  run docker exec "$(container)" /bin/su - root -mc "drush --version"

  [ "${status}" -eq 0 ]
  [[ "${output}" == *"7.0-dev"* ]]
}

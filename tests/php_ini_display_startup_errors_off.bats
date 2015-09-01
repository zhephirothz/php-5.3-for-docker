#!/usr/bin/env bats

DOCKER_COMPOSE_FILE="${BATS_TEST_DIRNAME}/php-5.3_ini_display_startup_errors_off.yml"

container() {
  echo "$(docker-compose -f ${DOCKER_COMPOSE_FILE} ps php-5.3 | grep php-5.3 | awk '{ print $1 }')"
}

setup() {
  docker-compose -f "${DOCKER_COMPOSE_FILE}" up -d

  sleep 10
}

teardown() {
  docker-compose -f "${DOCKER_COMPOSE_FILE}" kill
  docker-compose -f "${DOCKER_COMPOSE_FILE}" rm --force
}

@test "php-5.3: ini: display_startup_errors: off" {
  run docker exec "$(container)" /bin/su - root -lc "cat /usr/local/src/phpfarm/inst/current/etc/conf.d/display_startup_errors.ini | grep 'display_startup_errors'"

  [ "${status}" -eq 0 ]
  [[ "${output}" == *"Off"* ]]
}

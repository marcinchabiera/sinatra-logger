#!/bin/bash

# Parse arguments
while [ $# -gt 0 ]; do
    case "$1" in
        --pytest_args=*)
        pytest_args="${1#*=}"
        ;;
        --container_ver=*)
        container_ver="${1#*=}"
        ;;
        --test_env=*)
        test_env="${1#*=}"
        ;;
        *)
        echo "[ERROR] Invalid argument. Please review the list of accepted arguments."
        exit 1
    esac
    shift
done

# Load configuration variables
source config

# Evaluate path where the main directory of Test Runner is and use it to mount directory to container
test_runner_dir=$(cd ../ && pwd)
image_tag=${container_ver:-latest}
image_name_full=${IMAGE_NAME}:${image_tag}
test_env=${test_env:-devbox}
pytest_command="pytest ${pytest_args} --junitxml=../junit_report.xml -n 12"

echo "[START] --------- DOCKERIZED PYTEST TEST RUNNER ----------"

# Verify whether parameters have been provided, if so display command that will start the test run.
if [ -z "$pytest_args" ]
then
    echo "[ERROR] No Pytest arguments have been provided. Please provide them as a single string."
    exit 1
else
    echo "[TEST CMD]  ${pytest_command}"
fi

# Display image name:version
echo "[IMAGE] ${image_name_full}"

# Display container name:version
echo "[TEST ENV]  ${test_env}"

# Pull image manually so the newest version of a tag gets used event if it was previously stored locally
echo "[PULL] ${image_name_full}"
docker pull ${image_name_full}

# Run pytests in container
docker run --rm \
    -e TESTS_CONFIG_ENV_FILENAME=${test_env} \
    -v ${test_runner_dir}:/usr/src/test_runner \
    --network host ${image_name_full} \
    /bin/bash -c "/usr/src/cleanup_cache.sh && ${pytest_command}"

echo "[END] --------- DOCKERIZED PYTEST TEST RUNNER ----------"
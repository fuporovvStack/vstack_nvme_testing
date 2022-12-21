#!/usr/local/bin/bash

#
# Copyright (C) 2022 vStack.
# All rights reserved.
#

# SKIPPED, but need to be added:
# - create/delete/attach/detach ns
# - create/remove queues
# - need more fresh nvme cli version to have more subcommands supported

# TODO:
# FIND TEST_SET PASSED ON bhyve_nvme, then check on nvmf
# ADD dd/ENOCSP test if device size is not more near 1GB

. config.sh

MODE="normal" # "passthru" V "normal"
BIN="nvmecontrol"      # "nvme" V "nvmecontrol"

verify_args() # 1:NVME_DEV 2:NVME_NS 3:MODE 4:BIN 5:VERBOSITY
{
	local dev=${1}
	local ns=${2}
	local mode=${3}
	local bin=${4}
	local v=${5}

	if [ -b "$dev" ] || [ -c "$dev" ]; then
		echo "NVME_DEV=$dev"
	else
		echo "Cannot find nvme device:$dev"
		exit 1
	fi

	if [ -b "$ns" ] || [ -c "$ns" ]; then
		echo "NVME_NS=$ns"
	else
		echo "Cannot find nvme namespace:$ns"
		exit 1
	fi

	if [ "$mode" == "passthru" ] || [ "$mode" == "normal" ]; then
		echo "MODE=$mode"
	else
		echo "Unknown mode=$mode"
		exit 1
	fi

	if [ "$bin" == "nvme" ] || [ "$bin" == "nvmecontrol" ]; then
		echo "NVME BIN=$bin"
		local bin_path="$(which $bin)"
		if [ -z "$bin_path" ]; then
			echo "Cannot find nvme binary:$bin"
			exit 1
		fi
	else
		echo "Unknown nvme test binary: $bin"
		exit 1
	fi

	if [ "$v" == "true" ]; then
		echo "verbose mode enabled"
	fi
}

run_test() # 1: test_name.sh
{
	if [ "$VERBOSE" == "true" ]; then
		./scripts/${1} $NVME_DEV $NVME_NS $MODE $BIN
	else
		./scripts/${1} $NVME_DEV $NVME_NS $MODE $BIN > /dev/null 2>&1
	fi
}

verify_args "$NVME_DEV" "$NVME_NS" "$MODE" "$BIN" "$VERBOSE"

#TESTS_ALL="$(ls ./scripts)"
TESTS="$TESTS_BHYVE_LOCAL_NVME_NORMAL_NVMECONTROL"

echo "TESTS to run:"
echo "$TESTS"

passed=0
failed=0
not_implemented=0
for test in ${TESTS}; do
	echo "======== test=$test"
	run_test $test
	ret=$?
	if [ "$ret" == "0" ]; then
		passed=$(($passed + 1))
		echo "======== => PASSED"
	elif [ "$ret" == "127" ]; then
		not_implemented=$(($not_implemented + 1))
		echo "======== => NOT IMPLEMENTED"
	else
		failed=$(($failed + 1))
		echo "======== => FAILED"
	fi
done

echo "PASSED=$passed, FAILED=$failed NOT_IMPLEMENTED=$not_implemented"

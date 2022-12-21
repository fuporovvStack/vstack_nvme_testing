#!/usr/local/bin/bash

#
# Copyright (C) 2022 vStack.
# All rights reserved.
#

NVME_DEV=${1}
NVME_NS=${2}
MODE=${3}
BIN=${4}

nvme_cli_passthru()
{
	# NVME_LOG_ERROR
	nvme admin-passthru $NVME_DEV --opcode=02 --data-len=64 --cdw10=1 -r
	ret=$?
	if [ "$ret" != "0" ]; then
		exit 1
	fi

	# NVME_LOG_HEALTH_INFORMATION
	nvme admin-passthru $NVME_DEV --opcode=02 --data-len=64 --cdw10=2 -r
	ret=$?
	if [ "$ret" != "0" ]; then
		exit 1
	fi

	# NVME_LOG_FIRMWARE_SLOT
	nvme admin-passthru $NVME_DEV --opcode=02 --data-len=64 --cdw10=3 -r
	ret=$?
	if [ "$ret" != "0" ]; then
		exit 1
	fi
}

nvme_cli_normal()
{
	for id in 1 2 3 4; do
		nvme get-log $NVME_DEV --log-id=$id --log-len=512
		ret=$?
		if [ "$ret" != "0" ]; then
			exit 1
		fi
	done
}

nvme_control_passthru()
{
	dev=$(basename $NVME_DEV)

	# NVME_LOG_ERROR
	nvmecontrol admin-passthru $dev --opcode=02 --data-len=64 --cdw10=1 -r
	ret=$?
	if [ "$ret" != "0" ]; then
		exit 1
	fi

	# NVME_LOG_HEALTH_INFORMATION
	nvmecontrol admin-passthru $dev --opcode=02 --data-len=64 --cdw10=2 -r
	ret=$?
	if [ "$ret" != "0" ]; then
		exit 1
	fi

	# NVME_LOG_FIRMWARE_SLOT
	nvmecontrol admin-passthru $dev --opcode=02 --data-len=64 --cdw10=3 -r
	ret=$?
	if [ "$ret" != "0" ]; then
		exit 1
	fi

	# NVME_LOG_CHANGED_NAMESPACE
	nvmecontrol admin-passthru $dev --opcode=02 --data-len=64 --cdw10=4 -r
	ret=$?
	if [ "$ret" != "0" ]; then
		exit 1
	fi
}

nvme_control_normal()
{
	dev=$(basename $NVME_DEV)

	for id in 1 2 3 4; do
		nvmecontrol logpage -p $id $dev
		ret=$?
		if [ "$ret" != "0" ]; then
			exit 1
		fi
	done
}

# main
SUFFIX=""
if [ "$MODE" == "normal" ]; then
	SUFFIX="normal"
elif [ "$MODE" == "passthru" ]; then
	SUFFIX="passthru"
else
	exit 1
fi

if [ "$BIN" == "nvme" ]; then
	nvme_cli_${SUFFIX}
elif [ "$BIN" == "nvmecontrol" ]; then
	nvme_control_${SUFFIX}
else
	exit 1
fi


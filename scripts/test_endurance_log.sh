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
	# NVME_LOG_ENDURANCE_GROUP_INFORMATION
	nvme admin-passthru $NVME_DEV --opcode=02 --data-len=64 --cdw10=9 -r
	ret=$?
	if [ "$ret" != "0" ]; then
		exit 1
	fi
}

nvme_cli_normal()
{
	nvme endurance-log $NVME_DEV
	ret=$?
	if [ "$ret" != "0" ]; then
		exit 1
	fi
}

nvme_control_passthru()
{
	exit 127
}

nvme_control_normal()
{
	exit 127
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

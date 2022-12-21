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
	# NVME_OPC_IDENTIFY
	nvme admin-passthru $NVME_DEV --opcode=06 --data-len=64 --cdw10=1 -r
	ret=$?
	if [ "$ret" != "0" ]; then
		exit 1
	fi

	# NVME_OPC_IDENTIFY
	nvme admin-passthru $NVME_DEV -n 1 --opcode=06 --data-len=64 --cdw10=0 -r
	ret=$?
	if [ "$ret" != "0" ]; then
		exit 1
	fi
}

nvme_cli_normal()
{
	nvme id-ctrl $NVME_DEV
	ret=$?
	if [ "$ret" != "0" ]; then
		exit 1
	fi

	nvme id-ctrl $NVME_NS
	ret=$?
	if [ "$ret" != "0" ]; then
		exit 1
	fi

	nvme id-ns $NVME_DEV -n 1
	ret=$?
	if [ "$ret" != "0" ]; then
		exit 1
	fi
}

nvme_control_passthru()
{
	dev=$(basename $NVME_DEV)

	# NVME_OPC_IDENTIFY
	nvmecontrol admin-passthru $dev --opcode=06 --data-len=64 --cdw10=1 -r
	ret=$?
	if [ "$ret" != "0" ]; then
		exit 1
	fi

	# NVME_OPC_IDENTIFY
	nvmecontrol admin-passthru $dev -ns 1 --opcode=06 --data-len=64 --cdw10=0 -r
	ret=$?
	if [ "$ret" != "0" ]; then
		exit 1
	fi
}

nvme_control_normal()
{
	dev=$(basename $NVME_DEV)

	nvmecontrol identify $dev
	ret=$?
	if [ "$ret" != "0" ]; then
		exit 1
	fi
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


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
	nvme admin-passthru $NVME_DEV --opcode=10 --data-len=64 --cdw10=4 -r
	ret=$?
	if [ "$ret" != "0" ]; then
		exit 1
	fi

	nvme admin-passthru $NVME_DEV --opcode=10 --data-len=64 --cdw10=5 -r
	ret=$?
	if [ "$ret" != "0" ]; then
		exit 1
	fi
}

nvme_cli_normal()
{
	for feat in 4 5 7 9; do
		nvme get-feature $NVME_DEV -H -f $feat
		ret=$?
		if [ "$ret" != "0" ]; then
			exit 1
		fi
	done
}

nvme_control_passthru()
{
	dev=$(basename $NVME_DEV)

	nvmecontrol admin-passthru $dev --opcode=10 --data-len=64 --cdw10=4 -r
	ret=$?
	if [ "$ret" != "0" ]; then
		exit 1
	fi

	nvmecontrol admin-passthru $dev --opcode=10 --data-len=64 --cdw10=5 -r
	ret=$?
	if [ "$ret" != "0" ]; then
		exit 1
	fi
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

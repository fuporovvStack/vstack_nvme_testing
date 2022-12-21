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
	tmpfile=$(mktemp /tmp/nvme_out.XXXXXX)
	dd if=/dev/urandom of=$tmpfile bs=512 count=1

	# NVME_OPC_WRITE
	nvme io-passthru $NVME_NS --opcode=1 --namespace-id=1 --write --cdw10=0 --cdw11=0 --cdw12=0  --data-len=512 -i $tmpfile
	ret=$?
	if [ "$ret" != "0" ]; then
		exit 1
	fi
}

nvme_cli_normal()
{
	tmpfile=$(mktemp /tmp/nvme_out.XXXXXX)
	dd if=/dev/urandom of=$tmpfile bs=512 count=1

	# NVME_OPC_WRITE
	nvme write $NVME_NS -s 10 -c 1 -z 1024 -d $tmpfile
	ret=$?
	if [ "$ret" != "0" ]; then
		exit 1
	fi
}

nvme_control_passthru()
{
	ns=$(basename $NVME_NS)

        tmpfile=$(mktemp /tmp/nvme_out.XXXXXX)
        dd if=/dev/urandom of=$tmpfile bs=512 count=1

        # NVME_OPC_WRITE
        nvmecontrol io-passthru $ns --opcode=1 --namespace-id=1 --write --cdw10=0 --cdw11=0 --cdw12=0  --data-len=512 -i $tmpfile
        ret=$?
        if [ "$ret" != "0" ]; then
                exit 1
        fi
}

nvme_control_normal()
{
	exit 127

	ns=$(basename $NVME_NS)
	
	tmpfile=$(mktemp /tmp/nvme_out.XXXXXX)
        dd if=/dev/urandom of=$tmpfile bs=512 count=1

        # NVME_OPC_WRITE
        nvme io-passthru $ns --opcode=1 --namespace-id=1 --write --cdw10=0 --cdw11=0 --cdw12=0  --data-len=512 -i $tmpfile
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



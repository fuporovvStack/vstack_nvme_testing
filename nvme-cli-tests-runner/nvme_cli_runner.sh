#!/usr/local/bin/bash

# Linux user-BHYVE 5.15.0-53-generic #59~20.04.1-Ubuntu SMP Thu Oct 20 15:10:22 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux
TESTS_BHYVE_LOCAL_NVME="nvme_dsm_test nvme_error_log_test nvme_fw_log_test \
nvme_get_features_test nvme_id_ctrl_test nvme_read_write_test \
nvme_simple_template_test nvme_smart_log_test nvme_test nvme_test_io"

# FreeBSD fb 13.1-RELEASE FreeBSD 13.1-RELEASE releng/13.1-n250148-fc952ac2212 GENERIC amd64
TEST_BHYVE_LOCAL_NVME_FREEBSD="nvme_test nvme_test_io"

TESTS_ALL="nvme_create_max_ns_test nvme_fw_log_test nvme_lba_status_log_test \
nvme_writezeros_test nvme_dsm_test nvme_get_features_test \
nvme_read_write_test nvme_test nvme_attach_detach_ns_test nvme_error_log_test \
nvme_get_lba_status_test nvme_simple_template_test nvme_compare_test \
nvme_flush_test nvme_id_ctrl_test nvme_smart_log_test nvme_verify_test \
nvme_copy_test nvme_format_test nvme_id_ns_test nvme_test_io \
nvme_writeuncor_test"


TESTS=$(echo "$TESTS_BHYVE_LOCAL_NVME" | xargs -n1 | sort -u | xargs)

for test in ${TESTS}; do
	python3 -m "nose2" --verbose $test > /dev/null 2>&1
	ret=$?
	if [ "$ret" != "0" ]; then
		echo "$test => FAIL"
	else
		echo "$test => PASS"
	fi
done

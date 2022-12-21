#
# Copyright (C) 2022 vStack.
# All rights reserved.
#

NVME_DEV="/dev/nvme0"
NVME_NS="/dev/nvme0ns1"

VERBOSE="true" # "none"

# UBUNTU 20.04 (Linux user-BHYVE 5.15.0-53-generic #59~20.04.1-Ubuntu SMP Thu Oct 20 15:10:22 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux)
TESTS_BHYVE_LOCAL_NVME_PASSTHRU_NVME_CLI="test_changed_ns_list_log.sh \
test_getfeatures.sh test_identify.sh test_logpage.sh test_read.sh \
test_write_zeroes.sh test_write.sh"

# FreeBSD fb 13.1-RELEASE FreeBSD 13.1-RELEASE releng/13.1-n250148-fc952ac2212 GENERIC amd64
TESTS_BHYVE_LOCAL_NVME_PASSTHRU_NVME_CLI_FREEBSD="test_changed_ns_list_log.sh \
test_getfeatures.sh test_identify.sh test_logpage.sh"

# # UBUNTU 20.04 (Linux user-BHYVE 5.15.0-53-generic #59~20.04.1-Ubuntu SMP Thu Oct 20 15:10:22 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux)
TESTS_BHYVE_LOCAL_NVME_NORMAL_NVME_CLI="test_changed_ns_list_log.sh \
test_dsm.sh test_error_log.sh test_getfeatures.sh test_identify.sh \
test_list_ns.sh test_list_subsys.sh test_list.sh test_logpage.sh \
test_ns_descs.sh test_read.sh test_rescan.sh test_reset.sh test_setfeatrues.sh \
test_showregs.sh test_smart_log.sh test_vendor.sh test_write_zeroes.sh \
test_write.sh"

# FreeBSD fb 13.1-RELEASE FreeBSD 13.1-RELEASE releng/13.1-n250148-fc952ac2212 GENERIC amd64
TESTS_BHYVE_LOCAL_NVME_NORMAL_NVME_CLI_FREEBSD="test_changed_ns_list_log.sh \
test_error_log.sh test_getfeatures.sh test_identify.sh \
test_list_ns.sh test_list.sh test_logpage.sh \
test_ns_descs.sh test_setfeatrues.sh \
test_showregs.sh test_smart_log.sh test_vendor.sh"

# FreeBSD fb 13.1-RELEASE FreeBSD 13.1-RELEASE releng/13.1-n250148-fc952ac2212 GENERIC amd64
TESTS_BHYVE_LOCAL_NVME_PASSTHRU_NVMECONTROL="test_changed_ns_list_log.sh \
test_getfeatures.sh test_identify.sh test_logpage.sh test_read.sh \
test_write_zeroes.sh test_write.sh"

# FreeBSD fb 13.1-RELEASE FreeBSD 13.1-RELEASE releng/13.1-n250148-fc952ac2212 GENERIC amd64
TESTS_BHYVE_LOCAL_NVME_NORMAL_NVMECONTROL="test_changed_ns_list_log.sh \
test_error_log.sh test_identify.sh \
test_list.sh test_logpage.sh \
test_reset.sh test_smart_log.sh"

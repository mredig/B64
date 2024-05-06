#!/usr/bin/env bash

# imported env vars
# BEARER_TOKEN
# TAG_PREFIX
# REPO_NAME
# ORG_NAME
# IS_PROD_BUILD
# IS_STAGING_MERGE
# end imports

# exported env vars
# WORKFLOW_BUILD_NUMBER
# PREVIOUS_BUILD_NUMBER
# end exports


set -x
build_number=$(./CICD_Support/BuildNumber/buildnum.py --tag-prefix ${TAG_PREFIX})
new_build_number=$(($build_number + 1))
echo "Incremented build number: $new_build_number"

WORKFLOW_BUILD_NUMBER=${new_build_number}
if [[ ${IS_PROD_BUILD} == 0 ]] && [[ ${IS_STAGING_MERGE} == 0 ]]; then
	WORKFLOW_BUILD_NUMBER+="-ts$(date +%s)"
fi

echo WORKFLOW_BUILD_NUMBER=${WORKFLOW_BUILD_NUMBER} >> $CM_ENV
PREVIOUS_BUILD_NUMBER=${build_number}
echo PREVIOUS_BUILD_NUMBER=${PREVIOUS_BUILD_NUMBER} >> $CM_ENV

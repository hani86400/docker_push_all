#######################################################################
# source .github/workflows/dispatches.sh                 # 2025_12_29 #
#######################################################################
# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# : [export]
# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
export LV_WORKFLOW_DATA_NONE='{"ref":"main"}'
# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#
##
#
# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# : [functions] 
# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#######################################################################
# f u n c t i o n                                      [ 2025_07_01 ] #
                  do_dispatche(){
# $1 : WORKFLOW_ID
# $2 : WORKFLOW_DATA
#######################################################################
#
# # [REPOSITORY SETTING] 
#
LV_GITHUB_USER="${GITHUB_USER_1}"
LV_GITHUB_TOKEN="${GITHUB_TOKEN_1}"
LV_GITHUB_REMOTE_REPOSITORY_NAME='docker_push_all'

if    [[ -f "$2" ]]
then
echo "dispatche( $1 ) with dtat file( $2 ) containe $(cat $2)"
curl  -L -H "Accept: application/vnd.github+json" -H "Authorization: Bearer $LV_GITHUB_TOKEN" -H "X-GitHub-Api-Version: 2022-11-28" "https://api.github.com/repos/${LV_GITHUB_USER}/${LV_GITHUB_REMOTE_REPOSITORY_NAME}/actions/workflows/${1}/dispatches" -d @"$2"
elif [[ -z "$2" ]]
then
echo "dispatche( $1 ) with no data ( ${LV_WORKFLOW_DATA_NONE} )"
curl  -L -H "Accept: application/vnd.github+json" -H "Authorization: Bearer $LV_GITHUB_TOKEN" -H "X-GitHub-Api-Version: 2022-11-28" "https://api.github.com/repos/${LV_GITHUB_USER}/${LV_GITHUB_REMOTE_REPOSITORY_NAME}/actions/workflows/${1}/dispatches" -d "${LV_WORKFLOW_DATA_NONE}"
else
echo "dispatche( $1 ) with inline dtat: $2"
curl  -L -H "Accept: application/vnd.github+json" -H "Authorization: Bearer $LV_GITHUB_TOKEN" -H "X-GitHub-Api-Version: 2022-11-28" "https://api.github.com/repos/${LV_GITHUB_USER}/${LV_GITHUB_REMOTE_REPOSITORY_NAME}/actions/workflows/${1}/dispatches" -d "$2"
fi


unset LV_GITHUB_USER LV_GITHUB_TOKEN LV_GITHUB_REMOTE_REPOSITORY_NAME

} # f u n c t i o n [END] #############################################


#######################################################################
# f u n c t i o n                                      [ 2025_07_01 ] #
                  call_build_push_hub(){
#######################################################################
# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# : [WORKFLOW DATA & INPUTS] 
# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  WORKFLOW_PAYLOAD=$(
    jq -n \
      --arg LV_DOCKER_DIR "$1" \
      --arg LV_DOCKER_FILE "$2" \
      --arg LV_IMAGE_NAME "$3" \
      --arg LV_IMAGE_TAG "$4" \
      '{"ref":"main","inputs": {"DOCKER_DIR": $LV_DOCKER_DIR,"DOCKER_FILE": $LV_DOCKER_FILE, "IMAGE_NAME": $LV_IMAGE_NAME, "IMAGE_TAG": $LV_IMAGE_TAG}}'
  )
# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# : [WORKFLOW ID] 
# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
local     WORKFLOW_ID='build_push_hub.yml'
do_dispatche "${WORKFLOW_ID}"  "${WORKFLOW_PAYLOAD}"
} # f u n c t i o n [END] #############################################


#######################################################################
# f u n c t i o n                                      [ 2025_07_01 ] #
                  call_build_push_ghcr(){
#######################################################################
# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# : [WORKFLOW DATA & INPUTS] 
# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
  WORKFLOW_PAYLOAD=$(
    jq -n \
      --arg LV_DOCKER_DIR "$1" \
      --arg LV_DOCKER_FILE "$2" \
      --arg LV_IMAGE_NAME "$3" \
      --arg LV_IMAGE_TAG "$4" \
      '{"ref":"main","inputs": {"DOCKER_DIR": $LV_DOCKER_DIR,"DOCKER_FILE": $LV_DOCKER_FILE, "IMAGE_NAME": $LV_IMAGE_NAME, "IMAGE_TAG": $LV_IMAGE_TAG}}'
  )
# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# : [WORKFLOW ID] 
# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
local     WORKFLOW_ID='build_push_ghcr.yml'
do_dispatche "${WORKFLOW_ID}"  "${WORKFLOW_PAYLOAD}"
} # f u n c t i o n [END] #############################################

alias call_show_environment_variables="do_dispatche show_environment_variables.yml"

# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# : [initialize] 
# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#
##
#
# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# : [ M A I N]
# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
TO_CALL="
call_build_push_hub  'busybox_dynamic_httpd' 'Dockerfile' 'busybox_dynamic_httpd' '2512'
call_build_push_ghcr 'busybox_dynamic_httpd' 'Dockerfile' 'busybox_dynamic_httpd' '2512'
call_show_environment_variables
"
# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#
##
#
# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# : [finalize] 
# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
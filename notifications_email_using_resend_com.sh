#######################################################################
# source notifications_email_using_resend_com          [ 2025_12_28 ] #
#######################################################################

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# [begin] NOTIFICATIONS_EXPORT
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
THIS_SCRIPT='notifications.sh'
EMAIL_TIME=$(date +%d.%H.%M.%S)
# [end  ] NOTIFICATIONS_EXPORT ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
# [begin] NOTIFICATIONS_EXPORT_ALIAS
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

# [end  ] NOTIFICATIONS_EXPORT_ALIAS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#


notification_message() {
  local N_MSG="$1"
  local N_STATUS="$2"
  local N_LOG_LINK="$3"
  local N_DES_LINK="$4"
  local N_REMARK="$5"

  # colorize status
  if [ "$N_STATUS" = "OK" ]; then
    N_STATUS="<span style='color:green;font-weight:bold;'>OK</span>"
  elif [ "$N_STATUS" = "FAILED" ]; then
    N_STATUS="<span style='color:red;font-weight:bold;'>FAILED</span>"
  fi

  cat <<EOF
<table style='border-collapse:collapse;width:60%;border:1px solid #000;font-family:Arial;font-size:18px;'>
  <tr>
    <td style='border:1px solid #000;padding:6px;background:#f2f2f2;'>Message</td>
    <td style='border:1px solid #000;padding:6px;'>$N_MSG</td>
  </tr>
  <tr>
    <td style='border:1px solid #000;padding:6px;background:#f2f2f2;'>Status</td>
    <td style='border:1px solid #000;padding:6px;'>$N_STATUS</td>
  </tr>
EOF

  # append Log Link row if not ignored
  if [ "$N_LOG_LINK" != "ignore" ]; then
    cat <<EOF
  <tr>
    <td style='border:1px solid #000;padding:6px;background:#f2f2f2;'>Log Link</td>
    <td style='border:1px solid #000;padding:6px;'><a href='$N_LOG_LINK' style='color:#0645ad;'>$N_LOG_LINK</a></td>
  </tr>
EOF
  fi

  # append Description Link row if not ignored
  if [ "$N_DES_LINK" != "ignore" ]; then
    cat <<EOF
  <tr>
    <td style='border:1px solid #000;padding:6px;background:#f2f2f2;'>Description Link</td>
    <td style='border:1px solid #000;padding:6px;'><a href='$N_DES_LINK' style='color:#0645ad;'>$N_DES_LINK</a></td>
  </tr>
EOF
  fi

  # remark row is always printed
  cat <<EOF
  <tr>
    <td style='border:1px solid #000;padding:6px;background:#f2f2f2;'>Remark</td>
    <td style='border:1px solid #000;padding:6px;'>$N_REMARK</td>
  </tr>
</table>

<h3 style='font-family:Arial;margin-top:10px;'>notification center nc@x25.shop</h3>
EOF
}


#######################################################################
# f u n c t i o n                                      [ 2025_12_28 ] #
                  ff(){
# $1: ARG_1 (required - filename)
# $2: ARG_2 (optional)
#######################################################################
if [ $# -lt 1 ]
then
echo -e "fs_make_function \e[1;95m<FUNCTION_NAME>\e[0m \e[1;92m[SCRIPT_NAME]\e[0m \e[1;91m[SUBJECT_NAME]\e[0m"
return 1
fi


} # f u n c t i o n [END] #############################################


# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# : [initialize] 
# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#echo -e "\n$(date +%Y_%m_%d_%H_%M_%S)  BEGIN: ${THIS_SCRIPT} "  >> ${LOG_FILE}

# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#
#
# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# : [ M A I N ] 
# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
echo 'NOTIFICATION_' ; env | grep 'NOTIFICATION_'
if [ "$NOTIFICATION_STATUS" = "OK" ]; then
  EMAIL_SUBJECT="Docker Image Build Success ✅ ( ${NOTIFICATION_IMAGE_USER_NAME_TAG} )  ( ${EMAIL_TIME} )"
  N_STATUS="<span style='color:green;font-weight:bold;'>OK</span>"
  EMAIL_HTML=$(notification_message "${EMAIL_SUBJECT}" "${NOTIFICATION_STATUS}" "ignore" "${NOTIFICATION_IMAGE_LINK}" "docker pull ${NOTIFICATION_IMAGE_USER_NAME_TAG}" )
else 
  EMAIL_SUBJECT="Docker Image Build fail ❌ ( ${NOTIFICATION_IMAGE_USER_NAME_TAG} )  ( ${EMAIL_TIME} )"
  N_STATUS="<span style='color:red;font-weight:bold;'>FAILED</span>"
  EMAIL_HTML=$(notification_message "${EMAIL_SUBJECT}" "${NOTIFICATION_STATUS}" "${EMAIL_LOG_LINK}" "ignore" "Check log above" )    
fi
PAYLOAD=$(jq -n \
  --arg from "$EMAIL_FROM" \
  --arg to "$EMAIL_TO" \
  --arg subject "${EMAIL_SUBJECT}" \
  --arg html "$EMAIL_HTML" \
  '{from:$from,to:$to,subject:$subject,html:$html}')

curl -s -X POST "$RESEND_API_URL" -H "$RESEND_API_H_AUTH" -H 'Content-Type: application/json' -d "$PAYLOAD"
# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# : [finalize] 
# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#echo -e "\n$(date +%Y_%m_%d_%H_%M_%S)    END: ${THIS_SCRIPT} "  >> ${LOG_FILE}
# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

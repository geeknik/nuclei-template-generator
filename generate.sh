#!/bin/bash
# written by geeknik
# https://geeknik-labs.com/
# good luck out there! \m/
if [[ -z ${1} || -z ${2} ]]; then
    echo "Usage: generate.sh wordlistfile payloadfile > template_name.yaml"
    exit 1;
fi
    while [ -z "${template_Id}" ]; do
       read -p 'Template ID: ' template_Id
    done
    while [ -z "${template_Name}" ]; do
       read -p 'Template Name: ' template_Name
    done
    while [ -z "${template_Description}" ]; do
       read -p 'Template Description: ' template_Description
    done
    while [ -z "${template_Reference}" ]; do
       read -p 'Template Reference: ' template_Reference
    done
    while [ -z "${template_Author}" ]; do
       read -p 'Template Author: ' template_Author
    done
    while [ -z "${template_Severity}" ]; do
       read -p 'Template Severity: ' template_Severity
    done
    while [ -z "${template_Tags}" ]; do
       read -p 'Template Tags: ' template_Tags
    done
    while [ -z "${template_Method}" ]; do
       read -p 'Template Method (GET/POST): ' template_Method
    done
template_Payload=$(cat $2)
template_Baseurl=$(sed -e 's/^/       - "{{BaseURL}}\//' $1 > /tmp/template_TempFile_0;
                   sed -e 's/^/      /' /tmp/template_TempFile_0 > /tmp/template_TempFile_1;
                   cat /tmp/template_TempFile_1 | while read line; do echo '      '${line}${template_Payload}\"; done
                   rm /tmp/template_TempFile_*;
                   )
    while [ -z "${template_Matchers_Condition}" ]; do
       read -p 'Template Matchers Condition (and/or): ' template_Matchers_Condition
    done
    while [ -z "${template_Matchers_Type}" ]; do
       read -p 'Template Matchers Type (regex/word): ' template_Matchers_Type
    done
    if [ "$template_Matchers_Type" = "word" ]; then
        matchers_Type=words
    else
        matchers_Type=regex
    fi
    while [ -z "${template_Matchers_Part}" ]; do
       read -p 'Template Matchers Part (body/header): ' template_Matchers_Part
    done
    while [ -z "${template_Matchers_Words}" ]; do
       read -p 'Template '$matchers_Type' Matchers: ' template_Matchers_Words
    done
#basic nuclei template
cat << EOF
id: $template_Id

info:
  name: $template_Name
  description: $template_Description
  reference:
    - $template_Reference
  author: $template_Author
  severity: $template_Severity
  tags: $template_Tags

requests:
  - method: $template_Method
    path:
${template_Baseurl}

    matchers-condition: $template_Matchers_Condition
    matchers:
      - type: $template_Matchers_Type
        part: $template_Matchers_Part
        $matchers_Type:
          - '$template_Matchers_Words'
EOF

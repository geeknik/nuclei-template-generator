#!/bin/bash

function prompt_until_valid {
    local varname=$1
    local prompt=$2
    local valid_values=$3

    while [[ -z ${!varname} || ( -n "$valid_values" && ! " ${valid_values[*]} " =~ " ${!varname} " ) ]]; do
        read -p "$prompt" $varname
    done
}

# Check command line arguments
if [[ -z $1 || -z $2 ]]; then
    printf "Usage: generate.sh wordlistfile payloadfile > template_name.yaml\n"
    exit 1
fi

# Check files
for file in "$1" "$2"; do
    if [[ ! -r $file ]]; then
        printf "Error: File '%s' not found or not readable\n" "$file"
        exit 1
    fi
done

# Prompt for template details
prompt_until_valid template_id 'Template ID: '
prompt_until_valid template_name 'Template Name: '
prompt_until_valid template_description 'Template Description: '
prompt_until_valid template_reference 'Template Reference: '
prompt_until_valid template_author 'Template Author: '
prompt_until_valid template_severity 'Template Severity: ' 'info low medium high critical'
prompt_until_valid template_tags 'Template Tags: '
prompt_until_valid template_method 'Template Method (GET/POST): ' 'GET POST'

# Prepare payload and base URL
template_payload=$(cat "$2")
tempfile=$(mktemp)
sed -e 's/^/       - "{{BaseURL}}\//' "$1" > "$tempfile"
sed -e 's/^/      /' "$tempfile" > "$tempfile"
template_baseurl=$(awk -v tp="$template_payload" '{print "      " $0 tp "\""}' "$tempfile")
rm "$tempfile"

# Prompt for matchers details
prompt_until_valid template_matchers_condition 'Template Matchers Condition (and/or): ' 'and or'
prompt_until_valid template_matchers_type 'Template Matchers Type (regex/word): ' 'regex word'
prompt_until_valid template_matchers_part 'Template Matchers Part (body/header): ' 'body header'
prompt_until_valid template_matchers_words 'Template '"$template_matchers_type"' Matchers: '

# Output template
cat << EOF
id: $template_id

info:
  name: $template_name
  description: $template_description
  reference:
    - $template_reference
  author: $template_author
  severity: $template_severity
  tags: $template_tags

requests:
  - method: $template_method
    path:
$template_baseurl

    matchers-condition: $template_matchers_condition
    matchers:
      - type: $template_matchers_type
        part: $template_matchers_part
        ${template_matchers_type}s:
          - '$template_matchers_words'
EOF

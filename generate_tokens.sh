#!/bin/sh

TOTAL_TOKENS=$1
TITLE="🔑 Generating random TOKENS 👥"
# shellcheck disable=SC1046
if [ -z "$1" ]
	then
		TITLE="🔑 Generating random TOKEN 👤"
		TOTAL_TOKENS=1
fi
echo $TITLE
echo "================================"
seq $TOTAL_TOKENS | xargs -Iz ./generate_token.sh
echo "================================"

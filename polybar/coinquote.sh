#!/bin/env sh
#                _                         __
#    _________  (_)___  ____ ___  ______  / /____
#   / ___/ __ \/ / __ \/ __ `/ / / / __ \/ __/ _ \
#  / /__/ /_/ / / / / / /_/ / /_/ / /_/ / /_/  __/
#  \___/\____/_/_/ /_/\__, /\__,_/\____/\__/\___/
#                       /_/
# Coinmarketcap cryptocurrency price query script.
#
# This script sends a GET request to the coinmarket API and outputs the latest quote for <coin>/USD to stdout as a json string.
# You can pass any valid coinmarket symbol as the first commandline argument (uses ETH by default).
# A valid api key is required to be in a text file at ~/Documents/coinmarketcap/key.txt
# Dependencies: sed, curl, jq
# Note: only a small subset of endpoints are accessible via the free tier, these include:
#	* /v1/cryptocurrency/quotes/latest
#	* /v1/global-metrics/quotes/latest
# Unfortunately OHLCV data is not included in the free tier.

SYMBOL=$([ -n "$1" ] && echo "$1" || echo "ETH");
KEY_FILE="$HOME/Documents/coinmarketcap/key.txt";
BASE_URL="https://pro-api.coinmarketcap.com";
ENDPOINT="/v1/cryptocurrency/quotes/latest";

if [ -f "$KEY_FILE" ]; then
	API_KEY=$(sed 1q "$KEY_FILE");
	curl -s\
	-H "X-CMC_PRO_API_KEY: $API_KEY" \
	-H "Accept: application/json" \
	-d "symbol=$SYMBOL" \
	-G $BASE_URL$ENDPOINT | jq ".data.$SYMBOL.quote.USD";
else
	echo "Coinmarket API key file must be here: $KEY_FILE";
	return 1;
fi


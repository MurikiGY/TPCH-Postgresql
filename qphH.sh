#!/bin/bash

DATA=$(cat output | grep -E "seconds|mean" | head -n 26)

QUERIES=$(echo "$DATA" | head -n -3 | tail -n -22 | cut -d' ' -f3,5,6,7| sort -n -k1)
QUERY_TIME=$(echo "$QUERIES" | cut -d' ' -f 3 | awk '{s+=$1} END {print s}')
NEW_SALES=$(echo "$DATA" | head -n 1 | cut -d' ' -f 7)
OLD_SALES=$(echo "$DATA" | tail -n 1 | cut -d' ' -f 7)
GEO_MEAN=$(echo "$DATA" | tail -n 2 | head -n 1 | cut -d' ' -f 11)
TOTAL_TIME=$(echo "scale=3; $QUERY_TIME+$NEW_SALES+$OLD_SALES" | bc)


echo "ORIGINAL"
echo "$DATA"
echo "QUERIES"
echo "$QUERIES"

echo "TOTAL QUERY TIME"
echo "$QUERY_TIME"
echo "NEW SALES TIME"
echo "$NEW_SALES"
echo "OLD SALES TIME"
echo "$OLD_SALES"
echo "TOTAL TIME"
echo "$TOTAL_TIME"
echo "GEO MEAN"
echo "$GEO_MEAN"

REFRESH_GEO_MEAN=$(echo "scale=3; sqrt($NEW_SALES*$OLD_SALES)" | bc -l)
POWER=$(echo "scale=3; 3600/($GEO_MEAN*$REFRESH_GEO_MEAN)" | bc)

echo "POWER METRIC"
echo "$POWER"

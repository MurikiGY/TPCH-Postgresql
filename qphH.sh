#!/bin/bash

bash scripts/tcl/postgres/tproch/pg_tproch.sh > out.tmp

SF=1
S=1

DATA=$(cat out.tmp | grep -E "seconds|mean" | head -n 26)

QUERIES=$(echo "$DATA" | head -n -3 | tail -n -22 | cut -d' ' -f3,5,6,7| sort -n -k1)
QUERY_TIME=$(echo "$QUERIES" | cut -d' ' -f 3 | awk '{s+=$1} END {print s}')
NEW_SALES_TIME=$(echo "$DATA" | head -n 1 | cut -d' ' -f 7)
OLD_SALES_TIME=$(echo "$DATA" | tail -n 1 | cut -d' ' -f 7)
TOTAL_TIME=$(echo "scale=3; $QUERY_TIME+$NEW_SALES_TIME+$OLD_SALES_TIME" | bc)
GEO_MEAN=$(echo "$DATA" | tail -n 2 | head -n 1 | cut -d' ' -f 11)

echo "ORIGINAL"
echo "$DATA"
echo "QUERIES"
echo "$QUERIES"

echo "TOTAL QUERY TIME"
echo "$QUERY_TIME"
echo "NEW SALES TIME"
echo "$NEW_SALES_TIME"
echo "OLD SALES TIME"
echo "$OLD_SALES_TIME"
echo "TOTAL TIME"
echo "$TOTAL_TIME"
echo "GEO MEAN"
echo "$GEO_MEAN"

# POWER
REFRESH_GEO_MEAN=$(echo "scale=3; sqrt($NEW_SALES_TIME*$OLD_SALES_TIME)" | bc -l)
POWER=$(echo "scale=3; (3600*$SF)/($GEO_MEAN*$REFRESH_GEO_MEAN)" | bc)

echo "POWER METRIC"
echo "$POWER"

# THROUGHPUT
THROUGHPUT=$(echo "scale=3; ($S*22*3600)/($TOTAL_TIME*$SF)" | bc)

echo "THROUGHPUT"
echo "$THROUGHPUT"

# QPHH
QPHH=$(echo "scale=3; sqrt($POWER*$THROUGHPUT)" | bc -l)

echo "QPHH"
echo "$QPHH"


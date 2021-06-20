
###############################################################################
#
# Export variables to the default values
#  - first common variables, then model specific ones
#  - different machines, different defaults:
#
###############################################################################
STARTDATE="2021-04-01"
startd=$(date -d $STARTDATE +%s)
forecast_day=1
endd=$(( $startd + $forecast_day*24*3600 ))
export SYEAR=$(date -d @$startd '+%Y')
export SMONTH=$(date -d @$startd '+%m')
export SDAY=$(date -d @$startd '+%d')
export SHOUR=$(date -d @$startd '+%2H')
export EYEAR=$(date -d @$endd '+%Y')
export EMONTH=$(date -d @$endd '+%m')
export EDAY=$(date -d @$endd '+%d')
export EHOUR=$(date -d @$endd '+%2H')

export FHMAX=${FHMAX:-`expr $DAYS \* 24`}
#waves
#restsrt interval (hr)
export WW3RSTDTHR='0'
#output interval (hr)
export WW3OUTDTHR='1'
export WW3OUTPUTTYPE=' '
export OUTPARS_WAV="WND HS FP DP PHS PTP PDIR"
export CPLILINE='$'
export ICELINE='$'
export WINDLINE='$'
export CURRLINE='$'
export NFGRIDS=0
export NFGRIDS=1
export NMGRIDS=3
export CPLILINE="'glo_15mxt'  F T F T F F F"
export ww3gline="'gnh_10m' 'no' 'glo_15mxt' 'native' 'glo_15mxt'  'no' 'no' 'no'  1 10  0.00 1.00  F\n"
export ww3gline="${ww3gline}'gsh_15m' 'no' 'glo_15mxt' 'native' 'glo_15mxt'  'no' 'no' 'no'  2 20  0.00 1.00  F\n"
export ww3gline="${ww3gline}'aoc_9km' 'no' 'glo_15mxt' 'native' 'glo_15mxt'  'no' 'no' 'no'  3 30  0.00 1.00  F"



#!/bin/bash
module load intel netcdf nco cdo hpss wgrib2
CDO=/apps/cdo/1.9.10/gnu/1.9.10/bin/cdo

FIXwave=/scratch1/NCEPDEV/global/glopara/fix_nco_gfsv16/fix_wave_gfs/
GLBDUMP=/scratch1/NCEPDEV/global/glopara/dump
WGRIB2=/apps/wgrib2/2.0.8/intel/18.0.3.222/bin/wgrib2

STARTDATE="2021-04-02"
ENDDATE="2021-04-03"
start=$(date -d $STARTDATE +%s)
end=$(date -d $ENDDATE +%s)



#-----------------------------------------------------------------------------------#
#                                        ICE (Daily)                                #
#-----------------------------------------------------------------------------------#


d="$start"
while [[ $d -le $end ]]
do
    date -d @$d '+%Y-%m-%d %2H'
    YY=$(date -d @$d '+%Y')
    MM=$(date -d @$d '+%m')
    DD=$(date -d @$d '+%d')
    HH=$(date -d @$d '+%2H')
#-----------------------------------------------------------------------------------#
# HPSS retreival
# ice input per cycle is one single time step
#    FILEICE=(/NCEPPROD/hpssprod/runhistory/rh$YY/$YY$MM/$YY$MM$DD/com_gfs_prod_gfs.${YY}${MM}${DD}_${HH}.gfs.tar)
#    ICEGRB=(./gfs.$YY$MM$DD/$HH/atmos/gfs.t${HH}z.seaice.5min.blend.grb)
#   echo $FILEICE $ICEGRB
#   htar -xv -f $FILEICE $ICEGRB
#-----------------------------------------------------------------------------------#
# from Global Dump
cp $GLBDUMP/gfs.$YY$MM$DD/${HH}/gfs.t${HH}z.seaice.5min.blend.grb ./seaice_$YY$MM$DD${HH}_5min.blend.grb
# convert grb to netcdf
$CDO -f nc copy seaice_$YY$MM$DD${HH}_5min.blend.grb seaice_$YY$MM$DD${HH}_5min.blend.nc 2>&1 > wgrib.out
# convert time reference
$CDO  setreftime,1970-01-01,00:00:00,"seconds" seaice_$YY$MM$DD${HH}_5min.blend.nc seaice_$YY$MM$DD${HH}_5min.blend1.nc
#inverse lat
ncpdq -h -O -a -lat seaice_$YY$MM$DD${HH}_5min.blend1.nc seaice_$YY$MM$DD${HH}_5min.blend2.nc
mv seaice_$YY$MM$DD${HH}_5min.blend2.nc seaice_$YY$MM$DD${HH}_5min.blend1.nc
##ncatted -O -a calendar,time,o,c,standard seaice_$YY$MM$DD${HH}_5min.blend.nc seaice_$YY$MM$DD${HH}_5min.blend1.nc
##ncatted -O -a units,time,o,c,"day as %Y%m%d" seaice_$YY$MM$DD${HH}_5min.blend1.nc seaice_$YY$MM$DD${HH}_5min.blend2.nc
##mv seaice_$YY$MM$DD${HH}_5min.blend2.nc seaice_$YY$MM$DD${HH}_5min.blend1.nc
#ncap2 -O -s "time=${d}.0"\
#      -s "time@units=\"seconds since 1970-01-01 00:00:00\"" \
#      -s "time@calendar=\"standard\"" \
#seaice_$YY$MM$DD${HH}_5min.blend.nc seaice_$YY$MM$DD${HH}_5min.blend1.nc
#cp seaice_$YY$MM$DD${HH}_5min.blend.nc seaice_$YY$MM$DD${HH}_5min.blend1.nc
ncatted -O -a _FillValue,var91,o,f,-32766 seaice_$YY$MM$DD${HH}_5min.blend1.nc
#ncatted -a _FillValue,,m,f,1.0e36 seaice_$YY$MM$DD${HH}_5min.blend.nc_out.nc
#$CDO setmisstoc,999.0 seaice_$YY$MM$DD${HH}_5min.blend.nc_out1.nc seaice_$YY$MM$DD${HH}_5min.blend.nc_out.nc
#-----------------------------------------------------------------------------------#
#put all time steps together
 if [ $d == $start ]; then
    cp seaice_$YY$MM$DD${HH}_5min.blend1.nc gfs_ice.nc
 else
   mv gfs_ice.nc gfs_ice_tmp.nc
   ncrcat -h gfs_ice_tmp.nc seaice_$YY$MM$DD${HH}_5min.blend1.nc gfs_ice.nc
 fi
#-----------------------------------------------------------------------------------#
# Cleanup
rm -f seaice_$YY$MM$DD${HH}_5min.blend.nc seaice_$YY$MM$DD${HH}_5min.blend.grb
 d=$(( $d + 86400 ))
done
rm gfs_ice_tmp.nc


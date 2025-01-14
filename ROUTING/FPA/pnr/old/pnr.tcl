loadConfig ./Default.conf
commitConfig

floorPlan -d 1191.6 1191.6 0 0 0 0  
addRing -nets {vdd gnd} -type core_rings -follow io -layer_top metal7 -layer_bottom metal7 -layer_left metal6 -layer_right metal6 -width_top 5 -width_bottom 5 -width_right 5 -width_left 5 -spacing_top 2 -spacing_bottom 2 -spacing_left 2 -spacing_right 2 -offset_right 10 -offset_left 10 -offset_bottom 10 -offset_top 10
addStripe -nets {vdd gnd} -layer metal5 -width 5 -direction Horizontal -set_to_set_distance 100  -spacing 2  -start_y 350 -stop_y 850 -extend_to first_pad_ring
addStripe -nets {vdd gnd} -layer metal4 -width 5 -direction Vertical -set_to_set_distance 100 -spacing 2  -start_x 350 -stop_x 850 -extend_to first_pad_ring

cutRow -area 0 0 248 1191.6
cutRow -area 0 0 1191.6 248 
cutRow -area 0 943 1191.6 1191.6
cutRow -area 943 0 1191.6 1191.6

addIoFiller -prefix fill_io -cell EMPTY1HA
sroute -allowLayerChange 1 -blockPinTarget nearestTarget -crossoverViaBottomLayer M1 -crossoverViaTopLayer M7 -layerChangeRange {M1 M7} -nets {vdd gnd}

#addWellTap -cell -fixedGap 30
addEndCap -precap FILLER4EHD -postcap FILLER4EHD -prefix EndCap
saveDesign ./saving/washing_power.enc
timeDesign -prePlace -idealClock -drvReports -outDir ./reports/preplace_timing
timeDesign -prePlace -idealClock -hold -outDir ./reports/preplace_timing

setPlaceMode -clkGateAware true -congEffort medium -ignoreScan -timingDriven true
placeDesign
timeDesign -preCTS -idealClock -drvReports -outDir ./reports/place_timing
timeDesign -preCTS -idealClock -hold -outDir ./reports/place_timing

optDesign -preCTS 
saveDesign ./saving/SRAM_place.enc
timeDesign -preCTS -idealClock -drvReports -outDir ./reports/postplace_timing
timeDesign -preCTS -idealClock -hold -outDir ./reports/postplace_timing

setCTSMode -moveGate true -opt true -optArea true -optLatency true -routeClkNet true -routeBottomPreferredLayer 1 -routeTopPreferredLayer 4
clockDesign -specFile ./Clock.ctstch
timeDesign -postCTS -drvReports -outDir ./reports/cts_timing
timeDesign -postCTS -hold -outDir ./reports/cts_timing
 
optDesign -postCTS 
saveDesign ./saving/SRAM_cts.enc
timeDesign -postCTS -drvReports -outDir ./reports/postcts_timing
timeDesign -postCTS -hold -outDir ./reports/postcts_timing

routeDesign -globalDetail -viaOpt -wireOpt
timeDesign -postRoute -drvReports -outDir ./reports/route_timing
timeDesign -postRoute -hold -outDir ./reports/route_timing

optDesign -postRoute
optDesign -postRoute -hold
saveDesign ./saving/SRAM_route.enc
timeDesign -postRoute -drvReports -outDir ./reports/postroute_timing
timeDesign -postRoute -hold -outDir ./reports/postroute_timing
 
addFiller -cell {FILLER1HD FILLER2HD FILLER3HD FILLER4EHD FILLER8EHD FILLER16EHD FILLER32EHD FILLER64EHD}

extractRC -outfile ./SRAM_rc
write_sdf SRAM.sdf
saveNetlist ./SRAM.v -includePowerGround
report_power -leakage -outfile SRAM.pwr
saveDesign ./saving/SRAM.enc


#report_timing -path_type full_clock -net -from mips_core/datamem/ram_reg[109][4]/Q -to mips_core/datamem/ram_reg[109][4]/D  
#report_timing -path_type full_clock -net -from mips_core/datamem/ram_reg[109][4]/Q -to mips_core/datamem/ram_reg[109][4]/D -early
#ecoAddRepeater -term <pin name> -cell <buffer type>
#ecoPlace
#ecoRoute




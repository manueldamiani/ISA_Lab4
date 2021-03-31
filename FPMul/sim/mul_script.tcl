vcom -93 -work ./work ../src/MBE/constants.vhd
vcom -93 -work ./work ../src/MBE/Mux4to1.vhd
vcom -93 -work ./work ../src/MBE/MuxSel.vhd
vcom -93 -work ./work ../src/MBE/QjGen.vhd
vcom -93 -work ./work ../src/MBE/PPGen.vhd
vcom -93 -work ./work ../src/MBE/HA.vhd
vcom -93 -work ./work ../src/MBE/FA.vhd
vcom -93 -work ./work ../src/MBE/Dadda.vhd
vcom -93 -work ./work ../src/MBE/MBE.vhd

vcom -93 -work ./work ../src/fpnormalize_fpnormalize.vhd
vcom -93 -work ./work ../src/fpround_fpround.vhd
vcom -93 -work ./work ../src/packfp_packfp.vhd
vcom -93 -work ./work ../src/unpackfp_unpackfp.vhd
vcom -93 -work ./work ../src/regn0.vhd
vcom -93 -work ./work ../src/regn.vhd
vcom -93 -work ./work ../src/fpmul_single_cycle.vhd
vcom -93 -work ./work ../src/fpmul_stage1_struct.vhd
vcom -93 -work ./work ../src/fpmul_stage2_struct.vhd
vcom -93 -work ./work ../src/fpmul_stage3_struct.vhd
vcom -93 -work ./work ../src/fpmul_stage4_struct.vhd
vcom -93 -work ./work ../src/fpmul_pipeline.vhd

vlog -sv ../tb/top.sv

vsim top

run 4 us

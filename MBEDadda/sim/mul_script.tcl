vcom -93 -work ./work ../src/MBE/constants.vhd
vcom -93 -work ./work ../src/MBE/Mux4to1.vhd
vcom -93 -work ./work ../src/MBE/MuxSel.vhd
vcom -93 -work ./work ../src/MBE/QjGen.vhd
vcom -93 -work ./work ../src/MBE/PPGen.vhd
vcom -93 -work ./work ../src/MBE/HA.vhd
vcom -93 -work ./work ../src/MBE/FA.vhd
vcom -93 -work ./work ../src/MBE/Dadda.vhd
vcom -93 -work ./work ../src/MBE/MBE.vhd

vlog -sv ../tb/top.sv

vsim top

run 4 us

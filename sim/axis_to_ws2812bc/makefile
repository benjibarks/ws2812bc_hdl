setup_and_run_sim:
	vivado -mode 'gui' -source ./scripts/run_all.tcl &

run_sim:
	vivado -mode 'gui' -source ./scripts/run_sim.tcl ./vivado_project/sim_axis_to_ws2812bc.xpr &

open_existing_project:
	vivado ./vivado_project/sim_axis_to_ws2812bc.xpr &

clean:
	rm -rf ./vivado_project/*
	rm -rf ./.Xil
	rm -rf vivado*.*
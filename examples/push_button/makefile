setup_prj_and_run_build:
	vivado -mode 'gui' -source ./scripts/setup_prj_and_run_build.tcl &

setup_prj_and_run_build_batch:
	vivado -mode 'batch' -source ./scripts/setup_prj_and_run_build.tcl

setup_prj_and_run_sim:
	vivado -mode 'gui' -source ./scripts/setup_prj_and_run_sim.tcl &

setup_prj:
	vivado -mode 'gui' -source ./scripts/setup_prj.tcl &

open_existing_project:
	vivado ./vivado_project/push_button.xpr &

run_build:
	vivado -mode 'gui' -source ./scripts/run_build.tcl ./vivado_project/push_button.xpr &

run_sim:
	vivado -mode 'gui' -source ./scripts/run_sim.tcl ./vivado_project/push_button.xpr &

clean:
	rm -rf ./vivado_project/*
	rm -rf ./.Xil
	rm -rf vivado*.*
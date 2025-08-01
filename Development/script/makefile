#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
################################  MAKEFILE  ##############################################
#----File Name   : makefile
#----Description : makefile is used to automate tasks like compile,simulate etc
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Define SystemVerilog package and testbench files
pkg_files = ../sv/env/gpio_pkg.sv
design_file = ../sve/gpio.sv
path = ../top/tb.sv
sim = ../sim
log_files = *.vcd transcript *.wlf
# Default simulation parameters, can be overridden from command line
override wave ?= 0
SEED := $(shell shuf -i 0-999999 -n 1)
seed ?= $(SEED)
override testcase ?= gpio_test
override freq ?= 50MHz   
# Directory to save logs, named using simulation parameters
log_dir = $(sim)/testcase_$(testcase)_seed_$(seed)_freq_$(freq)
# Default target
all: compile simulate summary
# Compilation step
compile:
	@echo "Compiling..."
	@vlib work
	@vlog $(pkg_files) $(design_file) $(path) 
# Simulation step with or without waveform based on 'wave' variable
simulate: run_sim

run_sim:
	@echo "Simulating (seed = $(seed), testcase = $(testcase), wave = $(wave))"
	@vopt work.tb -o tb_opt +acc=arn
	@mkdir -p $(log_dir)
ifeq ($(wave),1)
	@vsim -c -assertdebug -msgmode both work.tb_opt \
		+UVM_TESTNAME=$(testcase) +sv_seed=$(seed) +freq=$(freq) \
		-do "add wave -r /*; run -all"
else
	@vsim -c -assertdebug -msgmode both work.tb_opt \
		+UVM_TESTNAME=$(testcase) +sv_seed=$(seed) +freq=$(freq) \
		-do "run -all"
endif
	@mv $(log_files) $(log_dir)

summary:
	@echo "==================== Test Summary ===================="
	@pass_count=$$(grep -r "TESTCASE PASSED" $(sim) | wc -l); \
	fail_count=$$(grep -r "TESTCASE FAILED" $(sim) | wc -l); \
	echo "Total Testcases Passed: $$pass_count"; \
	echo "Total Testcases Failed: $$fail_count"; \
	echo "======================================================"

# Clean only the compiled library
clean:
	rm -rf work
# Clean compiled library and simulation output
clean_all:
	rm -rf work
	rm -rf $(sim)/*


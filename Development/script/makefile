#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
################################  MAKEFILE  ##############################################
#----File Name   : makefile
#----Description : makefile is used to automate tasks like compile, simulate etc
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# Define SystemVerilog package and testbench files
pkg_files = ../sv/ral/ral_pkg.sv ../sv/seqlib/seq_pkg.sv ../sv/env/env_pkg.sv ../test/test_pkg.sv ../sv/env/gpio_files.sv
design_file = ../sve/gpio.sv
path = ../top/tb.sv
sim = ../sim
log_files =  transcript

# Default simulation parameters, can be overridden from command line
override wave ?= 0
SEED := $(shell shuf -i 0-999999 -n 1)
seed ?= $(SEED)
override no_of_in_tx ?= 0
override no_of_out_tx ?= 0
override pattern ?= ALT_0_1
override testcase ?= gpio_test
override freq ?= 50MHz
override DATA_WIDTH ?= 32
override ADDR_WIDTH ?= 32

# Directory to save logs, named using simulation parameters
log_dir = $(sim)/testcase_$(testcase)_seed_$(seed)_freq_$(freq)_in_tx_$(no_of_in_tx)_out_tx_$(no_of_out_tx)_pattern_$(pattern)_DATA_WIDTH_$(DATA_WIDTH)

# Default target
all: compile simulate summary

# Compilation step
compile:
	@echo "Compiling..."
	@vlib work
	@vlog +fcover -cover bcst +define+DATA_WIDTH=$(DATA_WIDTH) +define+ADDR_WIDTH=$(ADDR_WIDTH) $(design_file) $(pkg_files) $(path)

# Simulation step with or without waveform based on 'wave' variable
simulate: run_sim

run_sim:
	@echo "Simulating (seed = $(seed), testcase = $(testcase), wave = $(wave))"
	@vopt work.tb -o tb_opt -assertdebug +acc=arnp
	@mkdir -p $(log_dir)
ifeq ($(wave),1)
	@vsim -c -assertdebug  -fsmdebug -cvgperinstance -coverage -msgmode both work.tb_opt \
		+UVM_TESTNAME=$(testcase) +sv_seed=$(seed) +freq=$(freq) +no_of_in_tx=$(no_of_in_tx) +no_of_out_tx=$(no_of_out_tx) +pattern=$(pattern) \
		-do "add wave -r /* /tb/gen_my_module*/gpio_assertion_inst/*; run -all; coverage save -onexit $(log_dir)/$(testcase)"
else
	@vsim -c -assertdebug -cvgperinstance -coverage -msgmode both work.tb_opt \
		+UVM_TESTNAME=$(testcase) +sv_seed=$(seed) +freq=$(freq) +no_of_in_tx=$(no_of_in_tx) +no_of_out_tx=$(no_of_out_tx) +pattern=$(pattern) \
		-do "run -all; coverage save -onexit $(log_dir)/$(testcase)"
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



VERILATOR_BIN ?= verilator
YOSYS_BIN ?= yosys

VHDL_LINT_CMD := $(GHDL_BIN) -s $(GHDL_STD_OPT) --mb-comments $(GHDL_OPT) $(GHDL_WARNS)
VERILOG_LINT_CMD := $(VERILATOR_BIN) --lint-only $(VERILATOR_LINT_FLAGS)

.PHONY: lint lint-verilog lint-vhdl lint-yosys help-lint
lint: lint-verilog lint-vhdl lint-ghdl-synth lint-yosys

lint-verilog: $(VERILOG_FILES) config-vars
ifneq ($(strip $(VERILOG_FILES)),)
	$(VERILOG_LINT_CMD) $(VERILOG_FILES)
endif

lint-vhdl: $(VHDL_FILES) config-vars
ifneq ($(strip $(VHDL_FILES)),)
	$(VHDL_LINT_CMD) $(VHDL_FILES)
endif


lint-yosys: $(WORK_LIB)-obj$(VHDL_STD).cf $(VERILOG_FILES) config-vars
	$(YOSYS_BIN) $(YOSYS_GHDL_MODULE) -p "$(YOSYS_READ_VERILOG_CMD) $(YOSYS_READ_VHDL_CMD) proc; check -assert; hierarchy -check -top $(TOP); ls"

help-lint-verilog:
	@printf "%b" "$(CYAN)lint-verilog$(NO_COLOR):\n";
	@printf "%b" "VERILATOR_LINT_FLAGS \t extra options to pass to Verilator linting, e.g. add -Wno-<message> flags to globally supress warnings of type <message> or pass name of `.vlt` configuration file for more fine grained configuration. \n";
	@echo
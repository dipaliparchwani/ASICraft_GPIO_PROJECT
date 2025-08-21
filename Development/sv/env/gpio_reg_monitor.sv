//***************************************************************************************
//* FILE NAME    : gpio_reg_monitor.sv                                                  *
//* COMPONENT    : GPIO REGISTER MONITOR                                                *
//* DESCRIPTION  : Captures register read/write transactions from reg interface and     *
//*                send transaction to scoreboard via analysis port.                    *
//*                performs basic protocol checks like reset conditions.                *
//***************************************************************************************
class gpio_reg_monitor extends uvm_monitor;
  `uvm_component_utils(gpio_reg_monitor)
  
  // Virtual interface handle
  virtual gpio_reg_if grvif;
  gpio_reg_transaction mtr;

  // Analysis port to broadcast register transactions
  uvm_analysis_port #(gpio_reg_transaction) rmon_ap;

  // Constructor
  function new(string name = "gpio_reg_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  // Build phase: get virtual interface and create analysis port
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    rmon_ap = new("rmon_ap", this);
    if (!uvm_config_db#(virtual gpio_reg_if)::get(null, "tb.grif", "grvif", grvif))
      `uvm_error("GPIO_REG_MON", "Error getting Interface Handle")
  endfunction : build_phase

  // Run phase: monitor the interface for register read/write activities and send them to scoreboard via analysis port

  task monitor();
    mtr = gpio_reg_transaction::type_id::create("mtr");

    fork
      begin : sample
	@(posedge grvif.clk);
        @(grvif.WDATA or grvif.RDATA or grvif.WRITE or grvif.ADDRESS);
	wait(grvif.rst_n == 1'b1);
        mtr.ADDRESS = grvif.ADDRESS;
        mtr.WRITE   = grvif.WRITE;
        if(grvif.WRITE) begin
          mtr.WDATA   = grvif.WDATA;
          `uvm_info(get_type_name(),$sformatf("WRITE => ADDRESS: %0h, WDATA: %0h",mtr.ADDRESS, mtr.WDATA),UVM_NONE)
	end

        else begin
          mtr.RDATA   = grvif.RDATA;
          `uvm_info(get_full_name(),$sformatf("READ => ADDRESS: %0h, RDATA: %0h",mtr.ADDRESS, mtr.RDATA),UVM_NONE)
        end
        rmon_ap.write(mtr);
      end

      begin : Reset
        wait(grvif.rst_n == 1'b0);
	`uvm_info(get_type_name(),"due to reset assert in between transfe did not take place",UVM_HIGH)
      end
    join_any
    disable fork;
  endtask
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      wait(grvif.rst_n == 1'b1);
      monitor();
    end
  endtask

endclass

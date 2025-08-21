//#######################################################################################
//----PROJECT_NAME : GPIO VIP                                                           #
//----FILE_NAME    : gpio_monitor.sv                                                    #
//----COMPONENT    : GPIO MONITOR                                                       #  
//----DESCRIPTION  : Captures GPIO signals (in/out/intr) from the DUT via interface,    #
//----               creates transactions, broadcasts them through analysis port, and   #
//----               performs basic protocol checks like reset condition verification.  #
//#######################################################################################

class gpio_monitor extends uvm_monitor;
  `uvm_component_utils(gpio_monitor)

  // Virtual Interface Handle
  virtual gpio_if gvif;
  gpio_transaction mtr; 
  gpio_test_cfg tcfg;
 // int no_of_in_tx,no_of_out_tx;

  // Analysis Port to broadcast gpio_transaction
  uvm_analysis_port #(gpio_transaction) gmon_ap;

  // Constructor
  function new(string name = "gpio_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  // Build Phase - Get Interface Handle and create analysis port
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    gmon_ap = new("gmon_ap", this);
    
    // Get virtual interface from config DB
    if (!uvm_config_db#(virtual gpio_if)::get(null, "tb.gif", "gvif", gvif)) begin
      `uvm_error("GPIO_MON", "Error getting Interface Handle")
    end

    if(!uvm_config_db#(gpio_test_cfg)::get(this,"","tcfg",tcfg))
      `uvm_error(get_full_name(), "Error getting object Handle")

  endfunction : build_phase

  task monitor();
    mtr = gpio_transaction::type_id::create("mtr");

    fork
      begin : sample
        // Wait for clock edge followed by any signal change
       @(posedge gvif.clk);
       @(gvif.gpio_in  or  gvif.gpio_out or tcfg.tx_detect);
	 wait(gvif.rst_n == 1'b1);
        // Sample the GPIO signals
         mtr.gpio_in   = gvif.gpio_in;
         mtr.gpio_out  = gvif.gpio_out;
         //mtr.gpio_intr = gvif.gpio_intr;
         // Log sampled values
         `uvm_info(get_full_name(), $sformatf("GPIO_MON: gpio_in = %0h, gpio_out = %0h",mtr.gpio_in, mtr.gpio_out), UVM_NONE)
         gmon_ap.write(mtr);
      end

      begin : Reset
	wait(gvif.rst_n == 1'b0);
	`uvm_info(get_type_name(),"due to reset assert in between transfe did not take place",UVM_HIGH)
      end
    join_any
    disable fork;
  endtask

  // Run Phase - Capture GPIO signal activity
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      wait(gvif.rst_n == 1'b1);
      monitor();
    end
  endtask

endclass : gpio_monitor

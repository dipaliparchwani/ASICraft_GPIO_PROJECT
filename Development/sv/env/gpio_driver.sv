/**************************************************************************************************
*  PROJECT NAME : GPIO VIP                                                                        *
*  FILE NAME    : gpio_driver.sv                                                                  *
*  DESCRIPTION  :  It drives gpio_in signal based on the transaction received from the sequencer. *
*                  It connects to the GPIO interface and continuously drives data in run_phase.   *
***************************************************************************************************/

class gpio_driver extends uvm_driver #(gpio_transaction);
  `uvm_component_utils(gpio_driver)

  virtual gpio_if gvif; // Declare a Virtual interface for the GPIO interface 
  gpio_transaction dtr; // Declare an instance of the GPIO transaction
  gpio_test_cfg tcfg;
 // int no_of_in_tx,no_of_out_tx;

  // Constructor
  function new(string name = "gpio_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction  
  
  // Build phase of the GPIO driver
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual gpio_if)::get(null, "tb.gif", "gvif", gvif))
      `uvm_error(get_full_name(), "Error getting Interface Handle")
    if(!uvm_config_db#(gpio_test_cfg)::get(this,"","tcfg",tcfg))
      `uvm_error(get_full_name(), "Error getting object Handle")
  endfunction 

  // Run phase of the GPIO Driver
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    init(); // initialize the GPIO signals
    wait(gvif.rst_n == 1'b1); // wait for the reset to be asserted
    drive(); // start driving GPIO signals
  endtask

  // Task to initialize GPIO signals
  task init();
   // wait for the reset signal to be de-asserted
    wait(gvif.rst_n == 1'b0);
    gvif.gpio_in <= 'b0;
  endtask

  task drive();
    forever begin
      // create the GPIO transaction
      dtr = gpio_transaction::type_id::create("dtr");
      // get the next transaction item from the sequence
      seq_item_port.get_next_item(dtr); 

      fork
	begin : Transfer
	  // wait for the reset signal asserted
	  wait(gvif.rst_n == 1'b1);
          // Drive the gpio_in signal
	  @(posedge gvif.clk);
          gvif.gpio_in <= dtr.gpio_in;
          `uvm_info(get_type_name(), $sformatf("gpio_in value driven on interface : %0h", dtr.gpio_in), UVM_MEDIUM)
	  tcfg.tx_detect <= tcfg.tx_detect +1;
	end

        begin : Reset
	  // wait for the reset signal de-asserted
	  wait(gvif.rst_n == 1'b0);
	  // reset the signals
          gvif.gpio_in <= 'b0;
          `uvm_info(get_type_name(), "TRANSFER IS INTERRUPTED BY RESET", UVM_MEDIUM)
	end
      join_any
      disable fork;
      seq_item_port.item_done();
    end
  endtask : drive
endclass

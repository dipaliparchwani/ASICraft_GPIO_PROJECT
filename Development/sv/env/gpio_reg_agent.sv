//#######################################################################################
//----PROJECT_NAME : GPIO VIP                                                           #
//----FILE_NAME    : gpio_reg_agent.sv                                                  #
//----COMPONENT    : GPIO REGISTER AGENT                                                #  
//----DESCRIPTION  : Agent that encapsulates the GPIO register driver, sequencer, and   #
//----               monitor to generate and capture register-level transactions.       #
//#######################################################################################

class gpio_reg_agent extends uvm_agent;
  `uvm_component_utils(gpio_reg_agent)

  // Component handles
  gpio_reg_driver grdrv;
  gpio_reg_seqr   grseqr;
  gpio_reg_monitor grmon;

  // Constructor
  function new(input string name = "gpio_reg_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  // Build phase - create all subcomponents
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    grdrv  = gpio_reg_driver::type_id::create("grdrv", this);  // reg driver handle
    grmon  = gpio_reg_monitor::type_id::create("grmon", this); // reg monitor handle
    grseqr = gpio_reg_seqr::type_id::create("grseqr", this);   //reg sequencer handle
  endfunction : build_phase

  // Connect phase - connect sequencer and driver
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    grdrv.seq_item_port.connect(grseqr.seq_item_export);
  endfunction : connect_phase

endclass : gpio_reg_agent

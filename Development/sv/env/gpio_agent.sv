/**************************************************************************************************************/
/*                                                                                                            */
/*  PROJECT NAME : GPIO VIP                                                                                   */
/*  FILE NAME    : gpio_agent.sv                                                                              */
/*  COMPONENT    : GPIO Agent                                                                                 */
/*  DESCRIPTION  : The gpio_agent encapsulates the driver, monitor, and sequencer. It is responsible for      */
/*                 constructing and connecting these components.                                              */
/*                                                                                                            */
/**************************************************************************************************************/

class gpio_agent extends uvm_agent;
  `uvm_component_utils(gpio_agent)

  // Constructor
  function new(input string name = "gpio_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Component handles
  gpio_driver gdrv;      // Driver Handle
  gpio_seqr  gseqr;      // Sequencer Handle
  gpio_monitor gmon;     // Monitor Handle

  // Build phase - create all subcomponents
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    gdrv  = gpio_driver::type_id::create("gdrv", this);
    gmon  = gpio_monitor::type_id::create("gmon", this);
    gseqr = gpio_seqr::type_id::create("gseqr", this);
  endfunction

  // Connect phase - connect driver and sequencer
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    gdrv.seq_item_port.connect(gseqr.seq_item_export); // Enables communication between sequencer and driver
  endfunction

endclass

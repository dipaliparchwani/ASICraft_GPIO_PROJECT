class gpio_agent extends uvm_agent;
  `uvm_component_utils(gpio_agent);

  function new(input string name = "gpio_agent", uvm_component parent = null);
    super.new(name,parent);
  endfunction

  gpio_driver gdrv;
  gpio_seqr gseqr;
  gpio_monitor gmon;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    gdrv = gpio_driver::type_id::create("gdrv",this);
    gmon = gpio_monitor::type_id::create("gmon",this);
    gseqr = gpio_seqr::type_id::create("gseqr", this); 
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    gdrv.seq_item_port.connect(gseqr.seq_item_export);
  endfunction

endclass

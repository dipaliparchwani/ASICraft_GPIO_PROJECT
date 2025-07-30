class gpio_reg_agent extends uvm_agent;
  `uvm_component_utils(gpio_reg_agent);

  function new(input string name = "gpio_reg_agent", uvm_component parent = null);
    super.new(name,parent);
  endfunction

  gpio_reg_driver grdrv;
  gpio_reg_seqr grseqr;
  gpio_reg_monitor grmon;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    grdrv = gpio_reg_driver::type_id::create("grdrv",this);
    grmon = gpio_reg_monitor::type_id::create("grmon",this);
    $display("hello mon");
    grseqr = gpio_reg_seqr::type_id::create("grseqr", this); 
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    grdrv.seq_item_port.connect(grseqr.seq_item_export);
  endfunction

endclass

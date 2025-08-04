class gpio_output_functionality_test extends uvm_test;
  `uvm_component_utils(gpio_output_functionality_test)
 
  function new(input string name = "gpio_output_functionality_test", uvm_component parent = null);
    super.new(name,parent);
  endfunction
 
  gpio_env genv;
  out_reg_seq orseq;
 
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    genv = gpio_env::type_id::create("genv",this);
    orseq  = out_reg_seq::type_id::create("orseq");
  endfunction
 
  virtual task run_phase(uvm_phase phase);
  
    phase.raise_objection(this);
    orseq.regmodel = genv.regmodel;
    `uvm_info(get_full_name(),"before seq start",UVM_MEDIUM);
    fork
      orseq.start(genv.gr_agent.grseqr);
    join
    phase.drop_objection(this);
    `uvm_info(get_full_name(),"after seq start",UVM_MEDIUM);
  

  endtask
endclass
 

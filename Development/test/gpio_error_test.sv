class gpio_error_test extends gpio_base_test;
  `uvm_component_utils(gpio_error_test)
 
  function new(input string name = "gpio_error_test", uvm_component parent = null);
    super.new(name,parent);
  endfunction
 
  gpio_error_seq eseq;
  in_seq iseq;
 
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    eseq  = gpio_error_seq::type_id::create("eseq");
    iseq   = in_seq::type_id::create("iseq");
  endfunction
 
  virtual task run_phase(uvm_phase phase);
  
    phase.raise_objection(this);
    eseq.regmodel = genv.regmodel;
    `uvm_info(get_full_name(),"before seq start",UVM_MEDIUM);
    fork
      iseq.start(genv.g_agent.gseqr);
      eseq.start(genv.gr_agent.grseqr);
    join
    phase.drop_objection(this);
    `uvm_info(get_full_name(),"after seq start",UVM_MEDIUM);
  endtask

  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
  endfunction


endclass
 


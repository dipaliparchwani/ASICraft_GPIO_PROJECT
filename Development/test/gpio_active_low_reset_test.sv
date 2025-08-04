class gpio_active_low_reset_test extends gpio_base_test;
  `uvm_component_utils(gpio_active_low_reset_test)
 
  function new(input string name = "gpio_active_low_reset_test", uvm_component parent = null);
    super.new(name,parent);
  endfunction
 
  in_seq iseq;
  gpio_reg_reset_check_seq rseq;
 
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    rseq = gpio_reg_reset_check_seq::type_id::create("rseq");
    iseq   = in_seq::type_id::create("iseq");
  endfunction

  virtual task reset_phase(uvm_phase phase);
    super.reset_phase(phase);
  endtask
 
  virtual task run_phase(uvm_phase phase);
  
    phase.raise_objection(this);
    rseq.regmodel = genv.regmodel;
    `uvm_info(get_full_name(),"before seq start",UVM_MEDIUM);
    fork
      iseq.start(genv.g_agent.gseqr);
      rseq.start(genv.gr_agent.grseqr);
    join
    phase.drop_objection(this);
    `uvm_info(get_full_name(),"after seq start",UVM_MEDIUM);
  endtask

  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
  endfunction


endclass
 


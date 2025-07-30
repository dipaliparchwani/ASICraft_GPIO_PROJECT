class gpio_test extends uvm_test;
  `uvm_component_utils(gpio_test)
 
  function new(input string name = "gpio_test", uvm_component parent = null);
    super.new(name,parent);
  endfunction
 
  gpio_env genv;
  out_reg_seq orseq;
  in_seq iseq;
 
 
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    genv = gpio_env::type_id::create("genv",this);
    orseq  = out_reg_seq::type_id::create("orseq");
    iseq   = in_seq::type_id::create("iseq");
    $display("hello from test"); 
  // e.set_config_int( "*", "include_coverage", 0 );
  endfunction
 
  virtual task run_phase(uvm_phase phase);
  
    phase.raise_objection(this);
    orseq.regmodel = genv.regmodel;
    $display("befor seq start");
    fork
      orseq.start(genv.gr_agent.grseqr);
      iseq.start(genv.g_agent.gseqr);
    join
    $display("after seq start");
    phase.drop_objection(this);
  
   // phase.phase_done.set_drain_time(this, 200);

  endtask
endclass
 

class gpio_in_out_functionality_test extends gpio_base_test;
  `uvm_component_utils(gpio_in_out_functionality_test)
 
  function new(input string name = "gpio_in_out_functionality_test", uvm_component parent = null);
    super.new(name,parent);
  endfunction

  in_seq iseq;
  dir_out_seq doseq;
  out_drive_seq odseq; 
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    iseq      =   in_seq::type_id::create("iseq");
    doseq   =  dir_out_seq::type_id::create("doseq");
    odseq     =  out_drive_seq::type_id::create("odseq");
  endfunction
 
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    iseq.regmodel =  genv.regmodel;
    doseq.regmodel =  genv.regmodel;
    odseq.regmodel =  genv.regmodel;

    `uvm_info(get_type_name(),"before seq start",UVM_MEDIUM);
    //iseq.randomize();
   // iseq.start(genv.g_agent.gseqr);
    doseq.start(genv.gr_agent.grseqr);
    //odseq.start(genv.gr_agent.grseqr);
    `uvm_info(get_full_name(),"after seq start",UVM_MEDIUM);
    phase.drop_objection(this);
  endtask

  virtual task shutdown_phase(uvm_phase phase);
    super.shutdown_phase(phase);
  endtask


  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
  endfunction


endclass
 

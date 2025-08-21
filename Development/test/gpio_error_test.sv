class gpio_error_test extends gpio_base_test;
  `uvm_component_utils(gpio_error_test)
 
  function new(input string name = "gpio_error_test", uvm_component parent = null);
    super.new(name,parent);
  endfunction

  //dir_in_seq diseq;
  in_seq iseq;
  dir_out_seq doseq;
  out_drive_seq odseq; 
 // uvm_reg_hw_reset_seq rseq;
  //gpio_reg_mirror_seq mseq; 
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
   // diseq   =  dir_in_seq::type_id::create("diseq");
    iseq      =   in_seq::type_id::create("iseq");
   // irseq   =  in_read_seq::type_id::create("irseq");
    doseq   =  dir_out_seq::type_id::create("doseq");
    odseq     =  out_drive_seq::type_id::create("odseq");
    //rseq      =  uvm_reg_hw_reset_seq::type_id::create("rseq");
    //mseq     =   gpio_reg_mirror_seq ::type_id::create("mseq");
  endfunction
 
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    //diseq.regmodel =  genv.regmodel;
    iseq.regmodel =  genv.regmodel;
    doseq.regmodel =  genv.regmodel;
    odseq.regmodel =  genv.regmodel;
    //rseq.model =   genv.regmodel;
   // mseq.regmodel =   genv.regmodel;

    `uvm_info(get_type_name(),"before seq start",UVM_MEDIUM);
   // diseq.start(genv.gr_agent.grseqr);
    odseq.start(genv.gr_agent.grseqr);
    doseq.start(genv.gr_agent.grseqr);
    iseq.randomize();
    iseq.start(genv.g_agent.gseqr);
   // irseq.start(genv.gr_agent.grseqr);
   // mseq.start(genv.gr_agent.grseqr);
   // uvm_hdl_force("tb.rst_n",0);
   // #20;
  //  uvm_hdl_force("tb.rst_n",1);
   // rseq.start(genv.gr_agent.grseqr);
   // mseq.start(genv.gr_agent.grseqr);
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
 

class gpio_reset_test extends gpio_dir_random_test;
  `uvm_component_utils(gpio_reset_test)
 
  uvm_reg_hw_reset_seq rseq;
  int delay_cycles;

  function new(input string name = "gpio_reset_test", uvm_component parent = null);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    rseq = uvm_reg_hw_reset_seq::type_id::create("rseq");
  endfunction
 
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    drseq.regmodel =  genv.regmodel;
    odseq.regmodel =  genv.regmodel;
    rseq.model =      genv.regmodel;

    `uvm_info(get_type_name(),"before seq start",UVM_HIGH);
    drseq.randomize();
    drseq.start(genv.gr_agent.grseqr);
    fork
      iseq.start(genv.g_agent.gseqr);
      odseq.start(genv.gr_agent.grseqr);
      begin
        delay_cycles = $urandom_range(2, 4);  // random cycles between 10 and 50
        repeat(delay_cycles) @(posedge gvif.clk);
        `uvm_info(get_type_name(), $sformatf("Reset asserted after %0d cycles", delay_cycles), UVM_MEDIUM);	
        uvm_hdl_force("tb.rst_n",0);
        repeat(delay_cycles) @(posedge gvif.clk);
        uvm_hdl_force("tb.rst_n",1);
      end
    join
    rseq.start(genv.gr_agent.grseqr);
    iseq.start(genv.g_agent.gseqr);
    odseq.start(genv.gr_agent.grseqr);
    `uvm_info(get_full_name(),"after seq start",UVM_HIGH);
    phase.drop_objection(this);
  endtask

  virtual task shutdown_phase(uvm_phase phase);
    super.shutdown_phase(phase);
  endtask


  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
  endfunction


endclass

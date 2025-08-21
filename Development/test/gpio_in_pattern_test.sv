class gpio_in_pattern_test extends gpio_base_test;
  `uvm_component_utils(gpio_in_pattern_test)

  string pattern_str;
  gpio_in_pattern_seq in_seq;
  gpio_intr_config_base_seq intr_seq;
  //gpio_test_cfg tcfg;


  function new(string name = "gpio_in_pattern_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Create sequence instance
    in_seq = gpio_in_pattern_seq::type_id::create("in_seq");
    intr_seq = gpio_intr_config_base_seq::type_id::create("intr_seq");
    // --- Read pattern from plusarg ---
    if ($value$plusargs("pattern=%s", pattern_str)) begin
      // Map string to enum
      if (pattern_str == "WALKING_0")        in_seq.pattern_sel = gpio_transaction::WALKING_0;
      else if (pattern_str == "WALKING_1")   in_seq.pattern_sel = gpio_transaction::WALKING_1;
      else if (pattern_str == "WALKING_A")   in_seq.pattern_sel = gpio_transaction::WALKING_A;
      else if (pattern_str == "WALKING_5")   in_seq.pattern_sel = gpio_transaction::WALKING_5;
      else if (pattern_str == "INCREMENT")   in_seq.pattern_sel = gpio_transaction::INCREMENT;
      else if (pattern_str == "DECREMENT")   in_seq.pattern_sel = gpio_transaction::DECREMENT;
      else if (pattern_str == "ALT_0_1")     in_seq.pattern_sel = gpio_transaction::ALT_0_1;
      else begin
        `uvm_fatal("TEST", $sformatf("Unknown PATTERN_SEL: %s", pattern_str))
      end
    end else begin
      `uvm_warning("TEST", "PATTERN_SEL plusarg not found, using default ALT_0_1")
      in_seq.pattern_sel = gpio_transaction::ALT_0_1;
    end
    // Set desired pattern
    //in_seq.pattern_sel = gpio_transaction::ALT_0_1;

    // Set number of input transactions
    //tcfg.no_of_in_tx = 16; // You can change based on DATA_WIDTH or need
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    intr_seq.regmodel =  genv.regmodel;
    // Start the pattern input sequence
    intr_seq.start(genv.gr_agent.grseqr);
    in_seq.start(genv.g_agent.gseqr);

    phase.drop_objection(this);
  endtask

endclass


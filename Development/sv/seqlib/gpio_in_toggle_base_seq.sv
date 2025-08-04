class gpio_in_toggle_base_seq extends uvm_sequence #(gpio_transaction);
  `uvm_object_utils(gpio_in_toggle_base_seq)

  rand int no_of_txn;
  virtual gpio_if gvif;

  constraint tx_range_c {
    no_of_txn inside {[1:100]}; // Limit number of toggles if needed
  }

  function new(string name = "gpio_in_toggle_base_seq");
    super.new(name);
  endfunction

  task body();
    gpio_transaction str;
    if(!uvm_config_db#(virtual gpio_if)::get(null, "tb.gif", "gvif", gvif))
      `uvm_error("GPIO_SEQ", "Error getting Interface Handle")
    // Attempt to randomize no_of_txn; fallback to default if it fails
    if (!randomize()) begin
      `uvm_warning(get_type_name(), "Randomization of no_of_txn failed, using default = 4")
      no_of_txn = 4;
    end

    for (int i = 0; i < no_of_txn; i++) begin
      str = gpio_transaction::type_id::create($sformatf("str_%0d", i));
      start_item(str);
      str.gpio_in = 32'b0;
      str.gpio_in[0] = i % 2; // Toggle only bit 0: 0 → 1 → 0 → 1 ...
      finish_item(str);
    end
    @(posedge gvif.clk);
  endtask

endclass


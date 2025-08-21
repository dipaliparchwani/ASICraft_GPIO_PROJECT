class gpio_test_cfg extends uvm_object;

  `uvm_object_utils(gpio_test_cfg)

      int no_of_in_tx,
          no_of_out_tx,
	  tx_detect;

  function new(string name = "gpio_test_cfg");
    super.new(name);
  endfunction

endclass

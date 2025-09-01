
//***************************************************************************************
//* Project       : GPIO VIP                                                            *
//* File Name     : gpio_reg_driver.sv                                                  *
//* Component     : GPIO Register Driver                                                *
//* Description   : Drives register-level transactions to the DUT via reg interface     *
//*                 Handles register read/write operations using reg interface          *
//***************************************************************************************

class gpio_reg_driver extends uvm_driver #(gpio_reg_transaction);
  `uvm_component_utils(gpio_reg_driver)

  // Declare a Virtual Interface for GPIO REG driver                           
  virtual gpio_reg_if.reg_model grvif;
  // Declare an instance of GPIO REG transaction
  gpio_reg_transaction dtr;
  gpio_test_cfg tcfg;
  //int no_of_in_tx,no_of_out_tx;

  // Constructor                                                             
  function new(string name = "gpio_reg_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  //***************************************************************************
  //* Build Phase of the GPIO REG driver                      
  //***************************************************************************
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual gpio_reg_if)::get(null, "tb.grif", "grvif", grvif)) begin
      `uvm_error("GPIO_REG_DRV", "Error getting Interface Handle")
    end
    if(!uvm_config_db#(gpio_test_cfg)::get(this,"","tcfg",tcfg)) begin
      `uvm_error(get_full_name(), "Error getting object Handle")
    end

  endfunction

  //***************************************************************************
  //* Run Phase: Drive register interface signals                             *
  //***************************************************************************
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    init();
    wait(grvif.rst_n == 1'b1);
    drive();
  endtask
    

  task init();
    wait(grvif.rst_n == 1'b0);
    grvif.reg_model_cb.WRITE   <= 1'b0;
    grvif.reg_model_cb.WDATA   <= 'b0;
    grvif.reg_model_cb.ADDRESS <= 'b0;
  endtask

  task drive();
    forever begin
      dtr = gpio_reg_transaction::type_id::create("dtr");
      seq_item_port.get_next_item(dtr);

      fork 
	begin : Transfer
	  wait(grvif.rst_n == 1'b1);
	  @(posedge grvif.reg_model_cb);
          grvif.reg_model_cb.WRITE   <= dtr.WRITE;
          grvif.reg_model_cb.ADDRESS <= dtr.ADDRESS;
          grvif.reg_model_cb.WDATA   <= dtr.WDATA;
	  if(!dtr.WRITE) begin
	      @(posedge grvif.reg_model_cb);
	    dtr.RDATA     = grvif.reg_model_cb.RDATA;
	  end
	  `uvm_info(get_type_name(),$sformatf("ADDRESS: %0h, WRITE: %0h, WDATA: %0h, RDATA: %0h",grvif.reg_model_cb.ADDRESS, grvif.reg_model_cb.WRITE, grvif.reg_model_cb.WDATA,dtr.RDATA),UVM_NONE)
	  if(grvif.reg_model_cb.ADDRESS == 32'h04)begin
	    @(posedge grvif.reg_model_cb);
	    tcfg.tx_detect <= tcfg.tx_detect+1;
          end
        end

       begin : Reset
	 wait(grvif.rst_n == 1'b0)
         grvif.reg_model_cb.WRITE   <= 1'b0;
         grvif.reg_model_cb.WDATA   <= 'b0;
         grvif.reg_model_cb.ADDRESS <= 'b0;
	 `uvm_info(get_type_name(), "TRANSFER IS INTERRUPTED BY RESET", UVM_MEDIUM)
        end
      join_any
      disable fork;
     // `uvm_info("REG_DRV",$sformatf("ADDRESS: %0h, WRITE: %0h, RDATA: %0h",grvif.reg_model_cb.ADDRESS, grvif.reg_model_cb.WRITE, grvif.reg_model_cb.RDATA),UVM_NONE)
      seq_item_port.item_done();
     // `uvm_info("REG_DRV",$sformatf("ADDRESS: %0h, WRITE: %0h, RDATA: %0h",grvif.reg_model_cb.ADDRESS, grvif.reg_model_cb.WRITE, grvif.reg_model_cb.RDATA),UVM_NONE)
    end
  endtask : drive

endclass : gpio_reg_driver

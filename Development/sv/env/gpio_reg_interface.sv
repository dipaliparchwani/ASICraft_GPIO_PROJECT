//*********************************************************************************************************
//* FILE NAME    : gpio_reg_interface.sv
//* COMPONENT    : REG INTERFACE                                                                          *
//* DESCRIPTION  : Interface for GPIO register accesses Can be reused across multiple projects.           *
//                 Facilitates easy DUT connectivity and integration with verification components.        *
//*                                                                                                       *
//*********************************************************************************************************

interface gpio_reg_if(input logic clk, input logic rst_n);
  // Register Block Signals
  logic [`ADDR_WIDTH-1:0] ADDRESS;
  logic WRITE;
  logic [`DATA_WIDTH-1:0] WDATA;
  logic [`DATA_WIDTH-1:0] RDATA;

  // Used to identify and display the interface instance
  string inst_name = $sformatf("%m");


  // set the interface handle in the UVM config DB
  initial begin
    virtual gpio_reg_if grvif;
    grvif = interface::self();
    uvm_config_db#(virtual gpio_reg_if)::set(null, inst_name, "grvif", grvif);
  end


  /*
  // Clocking block for Register Model (Driver)
  clocking reg_model_cb @(posedge clk);
    default input #0 output #0;
    output WRITE, WDATA, ADDRESS;
    input  RDATA;
  endclocking

  // Clocking block for Monitor
  clocking reg_monitor_cb @(posedge clk);
    default input #0;
    input WRITE, WDATA, ADDRESS, RDATA;
  endclocking

  // Modport for driver/register model
  modport reg_model (clocking reg_model_cb, input clk, rst_n);

  // Modport for monitor
  modport reg_monitor (clocking reg_monitor_cb, input clk, rst_n);
  */

endinterface   

/**************************************************************************************************************/
/*                                                                                                            */
/*  PROJECT NAME : GPIO VIP                                                                                  */
/*  FILE NAME    : defines.sv                                                                              */
/*  COMPONENT    : Global Definitions                                                                        */
/*  DESCRIPTION  : This file contains global parameter definitions used across the GPIO verification environment. */
/*                                                                                                            */
/**************************************************************************************************************/

// Define the address bus width for register interface
`ifndef ADDR_WIDTH
  `define ADDR_WIDTH 32  // 32-bit wide address bus
`endif

// Define the data bus width for registers and transactions
`ifndef DATA_WIDTH
  `define DATA_WIDTH 32  // 32-bit wide data bus
`endif


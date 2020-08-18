//********************************************************************************************************
// Copyright(c) Cypress Semiconductor, 2014. All rights reserved.
// This model is the property of Cypress Semiconductor Corp.
// and is protected by the US copyright laws, any unauthorized
// copying and distribution is prohibited.
// Cypress reserves the right to change any of the functional 
// specifications without any prior notice.
// Cypress is not liable for any damages which may result from
// the use of this functional model
// -------------------------------------------------------------------------------------------------------
// File name : FRAM_SPI.v
// -------------------------------------------------------------------------------------------------------
// Functionality : Verilog behavourial Model for SPI F-RAM
// Source:  CYPRESS Data Sheet : 
// Version:  2.0 Feb 27, 2017
// -------------------------------------------------------------------------------------------------------
// Developed by CYPRESS SEMICONDUCTOR
//
// version |   author     | mod date | changes made
//    2.0  |    MEDU      | 27/02/17 |  Added VDD pin and tPU requirement
//    1.0  |    MEDU      | 14/03/14 |  New Model
// -------------------------------------------------------------------------------------------------------
// PART DESCRIPTION :
// Part:        All parts of F-RAM SPI
//
// Descripton:  Verilog behavourial Model  for  F-RAM SPI parts
// ----------------------------------------------------------------------------------------------------------  

`timescale 1ns/10ps
   

//
//      Slave for SPI protocol
//  00 && 11 modes (input data available on the positive edge of SCK)
//
module FRAM_SPI(CSB,HOLDB,SCK,SI,SO,WPB,VDD);
    output SO;
    input SI,SCK,CSB,HOLDB,WPB, VDD;
//
//      states
//
`define idle            "idle"
`define receivingInstruction    "receivingInstruction"
`define receivingAdd        "receivingAdd"
`define receivingData       "receivingData"
`define sendingData     "sendingData"
`define hold            "hold"
//

//
//---------------------------------------------------------------------
//  Read Configuration
//
`include "config.v"
parameter delta = 10;

//                        
//-----------------------------------------------------------------------
integer clkinCount, addrBytesCounter;
reg [31:0] i;
reg savSO;

integer tHALF_MIN;

reg [7:0] WREN, WRDI, RDSR, WRSR, READ, WRITE, FSTRD, SLEEP, RDID, SERIAL_NO;
reg [7:0] instruction, prevInstr;       // instruction
reg [8*22:1] state,nextState,savState;      // State machine controller
reg memProt;
reg [1:0] mode; 

reg [7:0] mem[0:(`Memblksize-1)];          // Real Memory Block (256K bits)
reg [7:0] realStatusRegister;

reg [`addrBits-1:0] addrMax, addrBegFullProt, addrBegHalfProt, addrBegQuarProt, addrBegProt, addrEndProt;

reg [`addrBits-1:0] Saddr;   

reg [7:0] tempReg,dataReg; 

integer display_val;
reg [7:0] dispStatusReg;

reg [7:0] Device_ID [0:8];
reg [7:0] Serial_No [0:7];
integer   id_cnt;
integer   sn_cnt;

reg sleep_mode;
reg sleep_enable_cmd;

reg msb_addr_bit;

reg tempSO;

time savTim;
time negCSBTim;
time posCSBTim;
time crtPer;
time negSCKTim;
time posSCKTim;
time lastStopTim;

time powerup_time = 0;
time powerdown_time = 0;

`define powerup_access ((powerup_time > powerdown_time) && (($time - powerup_time) >= tPU))

assign SO = (`powerup_access == 1)? tempSO : 'hz;

//####################### TIMING CHECK ###################################
    specify
    //
    //      timing checks for master send activity (IN)
    //
    //  clock
       $period(posedge SCK, 1000/fMAX); // fMAX in MHz, period in ns
       $width(posedge SCK, tCH);
       $width(negedge SCK, tCL);
    //
    //  data in
      $setuphold(SI, posedge SCK &&& (CSB == 0), tSU, tH);
    //
    endspecify
//######################## TASK ###################################

task displayStatusRegSense;
    begin

   dispStatusReg = tempReg;

    $display("-------------------------------");
    $display("Status Register %hH (%b): ",dispStatusReg,dispStatusReg);
    $display("-------------------------------");
    
    case (dispStatusReg[0])
        1'b0:
            $display("     Device ready");
        1'b1:
            $display("     Device not ready - write cycle in progress");
    endcase
    case (dispStatusReg[1])
        1'b0:
            $display("     Write disable");
        1'b1:
            $display("     Write enable");
    endcase
    case (dispStatusReg[7])
        1'b0:   if(hasWP == 1)
                $display("     Write protect enable: 0");
        1'b1:   if(hasWP == 1)
                $display("     Write protect enable: 1");
    endcase
    case (dispStatusReg[3:2])
        2'b00:
            $display("     Block protect:        no");
        2'b01:
            $display("     Block protect:        Quarter memory (%hH - %hH)",addrBegProt,addrEndProt);
        2'b10:
            $display("     Block protect:        Half memory (%hH - %hH)",addrBegProt,addrEndProt);
        2'b11:
            $display("     Block protect:        Entire memory (%hH - %hH)",addrBegProt,addrEndProt);
    endcase
    if(WPB == 0)
        $display("     WP pin:               %b (hardware protection)",WPB);
    else
        $display("     WP pin:               %b (no hardware protection)",WPB);
    end
endtask


//#################################### INITIAL ########################################

initial
    begin

    tHALF_MIN = tCH; 
     
    WREN =  8'b00000110;    // Enable Write
    WRDI =  8'b00000100;    // Disable Write
    RDSR =  8'b00000101;    // Read Status Register
    WRSR =  8'b00000001;    // Write Status Register
    READ =  8'b00000011;    // Read Data from Memory
    WRITE = 8'b00000010;    // Write Data to Memory
    FSTRD =  8'b00001011;          // Fast Read Command
    SLEEP =  8'b10111001;          // Sleep Command    
    RDID  =  8'b10011111;          // Read Device ID
    SERIAL_NO =   8'b11000011;          // Read Serial No
    
    Device_ID[0] = 8'h7F;
    Device_ID[1] = 8'h7F;
    Device_ID[2] = 8'h7F;
    Device_ID[3] = 8'h7F;
    Device_ID[4] = 8'h7F;
    Device_ID[5] = 8'h7F;
    Device_ID[6] = DEV_ID_MSB;    
    Device_ID[7] = DEV_ID_ISB;    
    Device_ID[8] = DEV_ID_LSB;        
    
    Serial_No[0]  = 0;
    Serial_No[1]  = 0;
    Serial_No[2]  = 0;
    Serial_No[3]  = 0;
    Serial_No[4]  = 0;
    Serial_No[5]  = 0;
    Serial_No[6]  = 0;
    Serial_No[7]  = 8'h0C;
    
    $display(" ");
    $display("===========================================================");
    $display("*");
    
    
    // Assign maximum possible address to addrMax
    
    addrMax = 0;
    for(i=0; i<`addrBits; i=i+1)
        addrMax[i]=1;   
        
    //
    
   addrBegFullProt = 0;
   addrBegHalfProt = (addrMax >> 1) + 1;
   addrBegQuarProt = addrBegHalfProt + (addrMax >> 2) + 1;
   $display("*");
   $display("* Max. address:                        %h",addrMax);
   $display("* Begin of full protection address:    %h",addrBegFullProt);
   $display("* Begin of half protection address:    %h",addrBegHalfProt);
   $display("* Begin of quarter protection address: %h",addrBegQuarProt );


   $display("*       fMAX = %d MHz",fMAX);
   $display("*       tCH  = %d ns",tCH);
   $display("*       tCL  = %d ns",tCL);
   $display("*       tD  = %d ns",tD);
   $display("*       tCSU = %d ns",tCSU);
   $display("*       tCSH = %d ns",tCSH);
   $display("*       tSU  = %d ns",tSU);
   $display("*       tH   = %d ns",tH);
   $display("*       tODV   = %d ns",tODV);
   $display("*       tOH  = %d ns",tOH);
   $display("*");
   $display("===========================================================");

    `ifdef initMemFile
        //
        // memory initialization with data from file
        //
        $readmemh(`initMemFile,mem);
        $display("Simulated memory array initialization with data from %s...",`initMemFile);
    `else
        //
        // memory initialization with ff
        //
        for(i=0; i<`Memblksize; i=i+1)
            begin
               mem[i] = 8'hff;
            end
        $display("Simulated memory array initialization with 8'hff...");
    `endif

    state = `idle;
    nextState = `idle;
    Saddr = 0;
    instruction = 8'h00;

    realStatusRegister = 8'h40;

    $display("SLAVE: initial Status Register = %hh",realStatusRegister);
    mode=2'b00;
    clkinCount = 0;
    tempSO = 1'bz;

    memProt = 1'b0;
    sleep_mode = 0;
    sleep_enable_cmd = 0;
    
end



//############################### ALWAYS ######################################

always @(negedge CSB) 
    negCSBTim = $time;

always @(posedge CSB) 
    posCSBTim = $time;

always @(negedge SCK) 
    negSCKTim = $time;

always @(posedge SCK) 
    posSCKTim = $time;

//------------------------------------------------------------------------------------
always @(posedge HOLDB)
    begin
    if(state == `hold && $time != 0 && !sleep_mode && `powerup_access)
        begin
        if(SCK == 1'b1)
            begin
            $display("SLAVE:  *** WARNING: Bad timing - HOLD up on clock=1 ...  ",$time);
            end
        #tLZ tempSO = savSO;
        state = savState;
        nextState = savState;
        $display("SLAVE:  Leaving HOLD state ...    ",$time);
        end
    end

//------------------------------------------------------------------------------------
always @(negedge HOLDB)     
    begin
    if($time != 0 && !sleep_mode && `powerup_access)
        begin
        if(SCK == 1'b1)
            begin
            $display("SLAVE:  *** WARNING: Bad timing - HOLD down on clock=1 ...    ",$time);
            end
        if(($time - negSCKTim) < tHH)
            begin
            $display("SLAVE:  *** WARNING: Bad timing - tHH not respected ...   ",$time);
            end
        savState = state;
        state = `hold;
        nextState = `hold;
        #tHZ tempSO = 1'bz;
        $display("SLAVE:  Entering HOLD state ...   ",$time);
        end
    end

//------------------------------------------------------------------------------------
always @(posedge CSB) 
if($time != 0 && !sleep_mode && `powerup_access)
begin
   #0 if((posCSBTim - negSCKTim) >= tCSH)       // CE High Time
   begin
      if( (SCK == 1'b0 && mode == 2'b00) || (SCK == 1'b1 && mode == 2'b11) ) 
          begin
         prevInstr = instruction;
         state = `idle;
         nextState = `idle;
         clkinCount = 0;
         #tOD tempSO = 1'bz;
         end
       else
          begin
          $display ("SLAVE: Warning...", $time);
          $display ("                   Illegal SCK status at CSB positive edge");
          prevInstr = instruction;
         state = `idle;
         nextState = `idle;
         clkinCount = 0;
         #tOD tempSO = 1'bz;
         end
       if(instruction != WREN)
           realStatusRegister[1] = 1'b0; 
           
       if(sleep_enable_cmd)
       begin
          sleep_mode = 1'b1;
          sleep_enable_cmd = 1'b0;
       end
   end
   else
   begin
        $display("SLAVE:  WARNING ", $time);
        $display("              STOP ignored (tCSH - CS Hold Time - not respected: %d < tCSH) ",posCSBTim - negSCKTim,$time);
      state = `idle;
      nextState = `idle; 
      #tOD tempSO = 1'bz; 
   end
end
//
//------------------------------------------------------------------------------------
// Detecting SPI MODE -
//            SCK = 0 on negedge of CSB => Mode 0
//            SCK = 1 on negedge of CSB => Mode 3
//-----------------------------------------------------------------------------------
// 
always @(negedge CSB)
begin
    if(`powerup_access)
    begin
	    #0 if((negCSBTim - posCSBTim) >= tD)
		begin
		if(SCK == 1'b0)
		    begin
		    mode = 2'b00;
		    if(sleep_mode)
		       #tREC sleep_mode = 1'b0;
		    nextState = `receivingInstruction;
		    end
		else
		    begin
		    mode = 2'b11;
		    #tHALF_MIN nextState = `receivingInstruction;
		    end
		end
	    else
		begin
		$display("***** SLAVE:  WARNING ");
		$display("              START ignored (tD - CS High Time - not respected: %d < tD) ",negCSBTim - posCSBTim,$time);
		end
    end
end

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// always @(posedge SCK && nextState != `idle && nextState != `hold )

always @(posedge SCK)
    begin
   #0 if(CSB != 1 && nextState != `idle && nextState != `hold && !sleep_mode && `powerup_access)
   begin
    state = nextState;
    case(state)
        `receivingInstruction:
            begin
            clkinCount = clkinCount + 1;
            case(clkinCount)
            1:
                begin
                if((posSCKTim-negCSBTim) >= tCSU)
                    begin
                    tempReg[7:0] = 8'b00000000;
                    #0 tempReg[0] = SI;
                    tempReg = tempReg << 1;
                    end
                else
                    begin
                    $display("***** SLAVE:  WARNING");
                    $display("              START ignored (tCSU - CS Setup Time - not respected: %d < tCSU) ",posSCKTim-negCSBTim,$time);
                    clkinCount = 0;
                    end
                end
            8:
                begin
                tempReg[0] = SI;
                $display("            SLAVE:  Instruction Received:      %b ", tempReg[7:0]);
                `ifdef ONE_BYTE_ADDR
                instruction  = {tempReg[7:4], 1'b0, tempReg[2:0]};
                msb_addr_bit = tempReg[3];
                `else
                instruction = tempReg;                
                `endif
                
                case(instruction)
                    WREN:
                        begin
                        if(realStatusRegister[0] == 1'b0)   // Check for Ready State
                            begin
                            state = `idle;
                            nextState = `idle;
                            realStatusRegister[1] = 1'b1;
                            $display("      statusRegister after WREN: %h",realStatusRegister);
                            #(2*tHALF_MIN) clkinCount = 0;
                            end
                        else
                            nextState = `idle;
                        end
                    WRDI:
                        begin
                        if(realStatusRegister[0] == 1'b0)   // Check for Ready State
                            begin
                            state = `idle;
                            nextState = `idle;
                            realStatusRegister[1] = 1'b0;
                            $display("      statusRegister after WRDI: %h",realStatusRegister);
                            #(2*tHALF_MIN) clkinCount = 0;
                            end
                        else
                            nextState = `idle;
                        end
                    RDSR:
                        begin
                        nextState = `sendingData;
                        #(tHALF_MIN) clkinCount = 0;
                        end
                    WRSR:                                 
                        begin
                        if(realStatusRegister[0] == 1'b0)   // Check for Busy State
                            begin
                            nextState = `receivingData;
                            #(2*tHALF_MIN) clkinCount = 0;
                            end
                        else
                            nextState = `idle;
                        end
                    READ:
                        begin
                        if(realStatusRegister[0] == 1'b0)   // Check for Busy State
                            begin
                            addrBytesCounter = addrBytes;
                            nextState = `receivingAdd;
                            #(tHALF_MIN) clkinCount = 0;
                            end
                        else
                            begin
                            nextState = `idle;
                            end
                        end
                        
                    FSTRD:
                        begin
                        if(hasfastread)
                        begin
                            if(realStatusRegister[0] == 1'b0)   // Check for Busy State
                                begin
                                addrBytesCounter = addrBytes;
                                nextState = `receivingAdd;
                                #(tHALF_MIN) clkinCount = 0;
                                end
                            else
                                begin
                                nextState = `idle;
                                end
                        end
                        else
                        begin
                            $display;
                            $display("Slave: WRONG INSTRUCTION CODE (%b) !",tempReg);
                            state = `idle;
                            nextState = `idle;
                            tempSO = 1'bz;
                        end
                        end

                    RDID:
                        begin
                        if(hasDeviceid)
                        begin
                            nextState = `sendingData;
                            #(tHALF_MIN) clkinCount = 0;
                            id_cnt = 0;
                        end                        
                        else
                        begin
                            $display;
                            $display("Slave: WRONG INSTRUCTION CODE (%b) !",tempReg);
                            state = `idle;
                            nextState = `idle;
                            tempSO = 1'bz;
                        end                         
                        end
                        
                    SERIAL_NO:
                        begin
                        if(hasSN)
                        begin
                            nextState = `sendingData;
                            #(tHALF_MIN) clkinCount = 0;
                            sn_cnt = 0;
                        end                        
                        else
                        begin
                            $display;
                            $display("Slave: WRONG INSTRUCTION CODE (%b) !",tempReg);
                            state = `idle;
                            nextState = `idle;
                            tempSO = 1'bz;
                        end                         
                        end
                        
                    WRITE:
                        begin
                        if(realStatusRegister[0] == 1'b0)   // Check for Busy State
                            begin
                            addrBytesCounter = addrBytes;
                            nextState = `receivingAdd;
                            #(2*tHALF_MIN) clkinCount = 0;

                            end
                        else
                            nextState = `idle;
                        end

                    SLEEP:
                        begin
                        if(hasSleep)
                        begin
                            state = `idle;
                            nextState = `idle;
                            $display("    SLAVE:   SLEEP Command Received");
                            sleep_enable_cmd = 1;
                            #(2*tHALF_MIN) clkinCount = 0;
                        end
                        else
                        begin
                            $display;
                            $display("Slave: WRONG INSTRUCTION CODE (%b) !",tempReg);
                            state = `idle;
                            nextState = `idle;
                            tempSO = 1'bz;
                        end                         
                        end
                default:
                        begin
                        $display;
                        $display("Slave: WRONG INSTRUCTION CODE (%b) !",tempReg);
                        state = `idle;
                        nextState = `idle;
                        tempSO = 1'bz;
                        end         
                endcase
                end
            default:
                begin
                tempReg[0] = SI;
                tempReg = tempReg << 1;
                end
            endcase
            end
        `receivingAdd:
            begin  
            clkinCount = clkinCount + 1;
            case(clkinCount)
            1:
                begin
                tempReg[7:0] = 8'b00000000;
                #0 tempReg[0] = SI;
                tempReg = tempReg << 1;
                end
            8:
                begin
                tempReg[0] = SI;
                case(addrBytesCounter)
                3:
                    begin
                    `ifdef THREE_BYTE_ADDR
                    nextState = `receivingAdd;
                    addrBytesCounter = addrBytesCounter-1;
                    #(2*tHALF_MIN) clkinCount = 0;
                    Saddr[`addrBits-1:16] = tempReg[`addrBits-16:0];
                    $display("            SLAVE:  rec. addr[%d:16]:                %h", `addrBits-1, tempReg[7:0]);
                    `endif
                    end
                    
                2:
                    begin
                    nextState = `receivingAdd;
                    addrBytesCounter = addrBytesCounter-1;
                    #(2*tHALF_MIN) clkinCount = 0;
                    `ifdef THREE_BYTE_ADDR
                    Saddr[15:8] = tempReg[7:0];                    
                    $display("            SLAVE:  rec. addr[15:8]:                %h",tempReg[7:0]);                    
                    `else
                    Saddr[`addrBits-1:8] = tempReg[`addrBits-8:0];
                    $display("            SLAVE:  rec. addr[%d:8]:                %h",`addrBits-1, tempReg[7:0]);                    
                    `endif
                    end
                1:
                    begin
                    
                    `ifdef ONE_BYTE_ADDR
                    Saddr[7:0] = tempReg[7:0];
                    Saddr[8:8] = msb_addr_bit;
                    `else
                    Saddr[7:0] = tempReg[7:0];
                    `endif
                    
                    $display("            SLAVE:  rec. addr[ 7:0]:             %h",Saddr[7:0]);
                    if( instruction == READ ) 
                        begin
                        nextState = `sendingData;
                        #(tHALF_MIN) clkinCount = 0;
                        $display ("         SLAVE: Next State - Sending Data");
                        end
                    else if( instruction == FSTRD ) 
                        begin
                        nextState = `receivingData;
                        #(tHALF_MIN) clkinCount = 0;
                        $display ("         SLAVE: Next State - Recieving Dummy Data");
                        end
                    else if (instruction == WRITE )
                        begin
                        nextState = `receivingData;
                        #(2*tHALF_MIN) clkinCount = 0;
                        $display ("         SLAVE: Next State - Recieving Data");
                        end
                       addrBytesCounter = addrBytesCounter-1;
                    end
                endcase
               end
            default:
                begin
                tempReg[0] = SI;
                tempReg = tempReg << 1;
                end
            endcase
            end
        `receivingData:
            begin
            clkinCount = clkinCount + 1;
            case(clkinCount)
            1:
                begin
                tempReg[7:0] = 8'b00000000;
                #0 tempReg[0] = SI;
                tempReg = tempReg << 1;
                end
            8:
                begin
                tempReg[0] = SI;
                dataReg[7:0] = tempReg[7:0];
                // $display("            SLAVE:  rec. data %d:      %h ", lSeq+1, dataReg[7:0]);
                case(instruction)
                    WRSR:
                       begin
                       if ( hasWP == 1 && WPB == 1'b0 && realStatusRegister[7] == 1'b1)
                          begin
                           $display("====== Status Register Protected - Unable to write status register");
                          end
                       else if (realStatusRegister[1] == 1'b1)
                          begin
                              realStatusRegister[3:2] = dataReg[3:2];   // RDY & WEL bits not written by WRSR
                               realStatusRegister[7] = dataReg[7];
                            
                              case(realStatusRegister[3:2])
                               2'b00:
                                   begin
                                      //    No protection
                                      memProt = 1'b0;
                                      addrBegProt = 0;              //need to decide GVCH
                                      addrEndProt = 0;
                                      $display("======No protection on memory");
                                   end
                               2'b11:
                                  begin
                                      //    Full protection
                                      memProt = 1'b1;
                                      addrBegProt = 0;
                                      addrEndProt = addrMax;
                                      $display("======Full protection on memory");
                                   end
                               2'b10:
                                   begin
                                      //    Half protection
                                      memProt = 1'b1;
                                      addrBegProt = addrBegHalfProt;
                                      addrEndProt = addrMax;
                                      $display("======Half protection on memory");
                                   end
                               2'b01:
                                   begin
                                      //    Quarter protection
                                      memProt = 1'b1;
                                      addrBegProt = addrBegQuarProt;
                                      addrEndProt = addrMax;
                                      $display("======Quarter protection on memory");
                                   end
                              endcase
                           end   
                        state =  `idle;
                        nextState = `idle;
                        #(2*tHALF_MIN) clkinCount = 0;
                    end
                    
                    WRITE:
                    begin
                        if(realStatusRegister[1] == 1'b1 && (memProt == 1'b0 || (Saddr < addrBegProt || Saddr > addrEndProt)))
                        begin
                            mem[Saddr] = dataReg[7:0];
                            $display("         SLAVE: Data Byte Written - Addr: %h Data: %h", Saddr, mem[Saddr]);
                            if (Saddr >= addrMax)
                                Saddr = 0;                 // Address Rollback
                            else
                                Saddr = Saddr + 1;
                        end
                        else if (realStatusRegister[1] == 1'b0)
                        begin
                            $display("      SLAVE: Write not enabled  (WEN = 0)");
                        end
                        else
                        begin
                            $display("      SLAVE: Address is Write Protected   Addr: %h", Saddr);
                        end
                           
                        nextState = `receivingData;
                        #(2*tHALF_MIN) clkinCount = 0;
                    end
                        
                    FSTRD:
                    begin
                        begin
                        nextState = `sendingData;
                        #(tHALF_MIN) clkinCount = 0;
                        $display("          SLAVE:  rec. dummy data");                        
                        $display ("         SLAVE: Next State - Sending Data");
                        end
                    end                         
                                        
                endcase // instruction
                end
            default:
                begin
                tempReg[0] = SI;
                tempReg = tempReg << 1;
                end
            endcase
            end
    endcase
    end
    end

//----------------------------------------------------------------------------------------

always @(negedge SCK)
    begin
    #0 if(CSB != 1 && nextState != `idle && nextState != `hold && !sleep_mode && `powerup_access)
   begin
    state = nextState;
    case(state)
        `sendingData:
            begin
            clkinCount = clkinCount+1;
            case(clkinCount)
                1:
                    begin
                    #((tODV- 1)/2) case(instruction)
                       RDSR:
                            begin
                            tempReg[7:0] = realStatusRegister[7:0];
                            if(state != `hold)
                                savSO = tempReg[7];
                               displayStatusRegSense;
                            end
                       
                       READ:
                            begin
                            tempReg[7:0] = mem[Saddr];
                            $display("               SLAVE: Sending Data - Addr: %h Data: %h", Saddr, mem[Saddr]);                            
                            if(state != `hold)
                                savSO = tempReg[7];
                                //$display("      mem[%h] = %h", Saddr, mem[Saddr]);
                                if (Saddr == addrMax)
                                    Saddr = 0;                 // Address Rollback
                                else
                                    Saddr = Saddr + 1;
                            end							  
                       
                       FSTRD:
                            begin
                            tempReg[7:0] = mem[Saddr];
                            $display("               SLAVE: Sending Data - Addr: %h Data: %h", Saddr, mem[Saddr]);
                            if(state != `hold)
                                savSO = tempReg[7];
                                //$display("      mem[%h] = %h", Saddr, mem[Saddr]);
                            if (Saddr == addrMax)
                                Saddr = 0;                 // Address Rollback
                            else
                                Saddr = Saddr + 1;
                            end
                       
                       RDID:
                            begin
                            tempReg[7:0] = Device_ID[id_cnt];
                            $display("%d               SLAVE: Sending Device ID - Data: %h", $time, Device_ID[id_cnt]);                            
                            if(state != `hold)
                                savSO = tempReg[7];
                            if(id_cnt < 8)
                               id_cnt = id_cnt + 1;
                            end
                            
                       SERIAL_NO:
                            begin
                            tempReg[7:0] = Serial_No[sn_cnt];
                            $display("%d               SLAVE: Sending Device ID - Data: %h", $time, Serial_No[sn_cnt]);                            
                            if(state != `hold)
                                savSO = tempReg[7];
                            if(sn_cnt < 7)
                               sn_cnt = sn_cnt + 1;
                            end                            
                            
                       endcase

                        #((tODV + 1)/2) tempSO = tempReg[7];
                        #0 tempReg = tempReg << 1;
                    end
                8:
                    begin
                    if(state != `hold)
                        savSO = tempReg[7];
                    #tODV tempSO = tempReg[7];
                    #0 tempReg = tempReg << 1;
                    #tODV clkinCount = 0;

                    case(instruction)
                        RDSR:
                            begin
                            state = `idle;
                            nextState = `idle;
                            end
                        READ:
                            begin
                            nextState = `sendingData;
                            end
                        FSTRD:
                            begin
                            nextState = `sendingData;
                            end                            
                    endcase
                    end
                default:
                    begin
                    if(state != `hold)
                        savSO = tempReg[7];
                    
                    #tODV tempSO = tempReg[7];
                    #0 tempReg = tempReg << 1;
                    end
            endcase
            end
        endcase
    end
    end


always @(posedge VDD)
begin
    $display("F-RAM power-up detected @ %d", $time);
    realStatusRegister[1] = 1'b0;     // reset WEL
    state = `idle;
    nextState = `idle;
    Saddr = 0;
    instruction = 8'h00;
    clkinCount = 0;
    tempSO = 1'bz;
    sleep_mode = 0;
    sleep_enable_cmd = 0;
    
    powerup_time = $time;
end

always @(negedge VDD)
begin
    powerdown_time = $time;
    $display("F-RAM power-down detected @ %d", $time);
end

endmodule


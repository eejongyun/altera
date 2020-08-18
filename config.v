//********************************************************************************************************
// This model is the property of Cypress Semiconductor Corp.
// and is protected by the US copyright laws, any unauthorized
// copying and distribution is prohibited.
// Cypress reserves the right to change any of the functional 
// specifications without any prior notice.
// Cypress is not liable for any damages which may result from
// the use of this functional model
// -------------------------------------------------------------------------------------------------------
// File name : config.v
// -------------------------------------------------------------------------------------------------------
// Functionality : Verilog behavourial Model for I2C F-RAM
// Source:  CYPRESS Data Sheet : 
// Version:  1.1 April 21, 2020
// -------------------------------------------------------------------------------------------------------
// Developed by CYPRESS SEMICONDUCTOR
//
// version |   author     | mod date | changes made
//    1.1  |    GVCH      | 21/04/20 | Added FM25V01A, CY15B128Q, FM25V02A, CY15B256Q
//    1.0  |    MEDU      | 11/03/14 |  New Model
// -------------------------------------------------------------------------------------------------------
// PART DESCRIPTION :
// Part:        All parts of F-RAM I2C
//
// Descripton:  Verilog behavourial Model  for  F-RAM I2C parts
// ----------------------------------------------------------------------------------------------------------  

//*******************************************************
// Define the F-RAM part
//*******************************************************
`define FM25V02

`ifdef CY15B104Q
   `define addrBits 19
   `define Memblksize 524288
   `define THREE_BYTE_ADDR   
   
   parameter Vddmax    =  3.6;
   parameter hasWP = 1;
   parameter hasSleep = 1; 
   parameter hasDeviceid = 1;            
   parameter hasSN = 0;
   parameter tPU = 1000000;   
   parameter tREC = 450000;
   parameter hasfastread = 1;                  
   
   parameter addrBytes = 3;
   
   parameter DEV_ID_MSB = 8'hC2;
   parameter DEV_ID_ISB = 8'h26;
   parameter DEV_ID_LSB = 8'h08;   
   
   parameter fMAX  = 40;     // Max. frequency (Mz) 

   parameter tCH = 11;       // min. SCK High Time
   parameter tCL = 11;       // min. SCK LOw Time
 
   parameter tD   = 40;      // min. CS High Time
   parameter tCSU = 10;      // min. CS Setup Time
   parameter tCSH = 10;      // min. CS HOLD Time

   parameter tSU = 5;        // min. Data In Setup Time
   parameter tH  = 5;        // min. Data In Hold Time 

   parameter tODV = 9;       // max. Output Valid from Clock Low
   parameter tOH  = 0;       // min. Output HOLD time
   parameter tOD  = 12;      // max. Output Disable Time

   parameter tHS = 10;       // min. HOLD Setup Time
   parameter tHH = 10;       // min. HOLD Hold Time
   parameter tLZ = 20;       // max. HOLD to Output Low Z
   parameter tHZ = 20;       // max. HOLD to Output High Z   
   
`endif

`ifdef FM25V20
   `define addrBits 18
   `define Memblksize 262144
   `define THREE_BYTE_ADDR
      
   parameter Vddmax    =  3.6;      
   parameter hasWP = 1;
   parameter hasSleep = 1;      
   parameter hasDeviceid = 1;         
   parameter hasSN = 0;
   parameter tPU = 1000000;
   parameter tREC = 450000;
   parameter hasfastread = 1;                     

   parameter addrBytes = 3;
   
   parameter DEV_ID_MSB = 8'hC2;
   parameter DEV_ID_ISB = 8'h25;
   parameter DEV_ID_LSB = 8'h00;
   
   parameter fMAX  = 40;     // Max. frequency (Mz) 

   parameter tCH = 11;       // min. SCK High Time
   parameter tCL = 11;       // min. SCK LOw Time
 
   parameter tD   = 40;      // min. CS High Time
   parameter tCSU = 10;      // min. CS Setup Time
   parameter tCSH = 10;      // min. CS HOLD Time

   parameter tSU = 5;        // min. Data In Setup Time
   parameter tH  = 5;        // min. Data In Hold Time 

   parameter tODV = 9;       // max. Output Valid from Clock Low
   parameter tOH  = 0;       // min. Output HOLD time
   parameter tOD  = 12;      // max. Output Disable Time

   parameter tHS = 10;       // min. HOLD Setup Time
   parameter tHH = 10;       // min. HOLD Hold Time
   parameter tLZ = 20;       // max. HOLD to Output Low Z
   parameter tHZ = 20;       // max. HOLD to Output High Z

`endif

`ifdef FM25V20A
   `define addrBits 18
   `define Memblksize 262144
   `define THREE_BYTE_ADDR   
   
   parameter Vddmax    =  3.6;
   parameter hasWP = 1;
   parameter hasSleep = 1; 
   parameter hasDeviceid = 1;            
   parameter hasSN = 0;
   parameter tPU = 1000000;   
   parameter tREC = 450000;
   parameter hasfastread = 1;                  
   
   parameter addrBytes = 3;
   
   parameter DEV_ID_MSB = 8'hC2;
   parameter DEV_ID_ISB = 8'h25;
   parameter DEV_ID_LSB = 8'h08;   
   
   parameter fMAX  = 40;     // Max. frequency (Mz) 

   parameter tCH = 11;       // min. SCK High Time
   parameter tCL = 11;       // min. SCK LOw Time
 
   parameter tD   = 40;      // min. CS High Time
   parameter tCSU = 10;      // min. CS Setup Time
   parameter tCSH = 10;      // min. CS HOLD Time

   parameter tSU = 5;        // min. Data In Setup Time
   parameter tH  = 5;        // min. Data In Hold Time 

   parameter tODV = 9;       // max. Output Valid from Clock Low
   parameter tOH  = 0;       // min. Output HOLD time
   parameter tOD  = 12;      // max. Output Disable Time

   parameter tHS = 10;       // min. HOLD Setup Time
   parameter tHH = 10;       // min. HOLD Hold Time
   parameter tLZ = 20;       // max. HOLD to Output Low Z
   parameter tHZ = 20;       // max. HOLD to Output High Z   
   
`endif

`ifdef FM25H20
   `define addrBits 18
   `define Memblksize 262144
   `define THREE_BYTE_ADDR
   
      
   parameter Vddmax    =  3.6;      
   parameter hasWP = 1;
   parameter hasSleep = 1;     
   parameter hasDeviceid = 0;            
   parameter hasSN = 0;
   parameter tPU = 1000000;    
   parameter tREC = 450000;
   parameter hasfastread = 0;               

   parameter addrBytes = 3;   
   
   parameter DEV_ID_MSB = 8'h00;
   parameter DEV_ID_ISB = 8'h00;
   parameter DEV_ID_LSB = 8'h00;   
   
   parameter fMAX  = 40;     // Max. frequency (Mz) 

   parameter tCH = 11;       // min. SCK High Time
   parameter tCL = 11;       // min. SCK LOw Time
 
   parameter tD   = 40;      // min. CS High Time
   parameter tCSU = 10;      // min. CS Setup Time
   parameter tCSH = 10;      // min. CS HOLD Time

   parameter tSU = 5;        // min. Data In Setup Time
   parameter tH  = 5;        // min. Data In Hold Time 

   parameter tODV = 9;       // max. Output Valid from Clock Low
   parameter tOH  = 0;       // min. Output HOLD time
   parameter tOD  = 12;      // max. Output Disable Time

   parameter tHS = 10;       // min. HOLD Setup Time
   parameter tHH = 10;       // min. HOLD Hold Time
   parameter tLZ = 20;       // max. HOLD to Output Low Z
   parameter tHZ = 20;       // max. HOLD to Output High Z
   
`endif

`ifdef FM25V10
   `define addrBits 17
   `define Memblksize 131072
   `define THREE_BYTE_ADDR
   
      
   parameter Vddmax    =  3.6;      
   parameter hasWP = 1;
   parameter hasSleep = 1; 
   parameter hasDeviceid = 1;            
   parameter hasSN = 0;
   parameter tPU = 250000;  
   parameter tREC = 400000;
   parameter hasfastread = 1;               
   
   parameter addrBytes = 3;   
   
   parameter DEV_ID_MSB = 8'hC2;
   parameter DEV_ID_ISB = 8'h24;
   parameter DEV_ID_LSB = 8'h00;  

   parameter fMAX  = 40;     // Max. frequency (Mz) 

   parameter tCH = 11;       // min. SCK High Time
   parameter tCL = 11;       // min. SCK LOw Time
 
   parameter tD   = 40;      // min. CS High Time
   parameter tCSU = 10;      // min. CS Setup Time
   parameter tCSH = 10;      // min. CS HOLD Time

   parameter tSU = 5;        // min. Data In Setup Time
   parameter tH  = 5;        // min. Data In Hold Time 

   parameter tODV = 9;       // max. Output Valid from Clock Low
   parameter tOH  = 0;       // min. Output HOLD time
   parameter tOD  = 12;      // max. Output Disable Time

   parameter tHS = 10;       // min. HOLD Setup Time
   parameter tHH = 10;       // min. HOLD Hold Time
   parameter tLZ = 20;       // max. HOLD to Output Low Z
   parameter tHZ = 20;       // max. HOLD to Output High Z
   
`endif

`ifdef FM25VN10
   `define addrBits 17
   `define Memblksize 131072
   `define THREE_BYTE_ADDR
   
      
   parameter Vddmax    =  3.6;      
   parameter hasWP = 1;
   parameter hasSleep = 1;   
   parameter hasDeviceid = 1;            
   parameter hasSN = 1;
   parameter tPU = 250000;     
   parameter tREC = 400000;
   parameter hasfastread = 1;               
   
   
   parameter addrBytes = 3;   
   
   parameter DEV_ID_MSB = 8'hC2;
   parameter DEV_ID_ISB = 8'h24;
   parameter DEV_ID_LSB = 8'h00;     
   
   parameter fMAX  = 40;     // Max. frequency (Mz) 

   parameter tCH = 11;       // min. SCK High Time
   parameter tCL = 11;       // min. SCK LOw Time
 
   parameter tD   = 40;      // min. CS High Time
   parameter tCSU = 10;      // min. CS Setup Time
   parameter tCSH = 10;      // min. CS HOLD Time

   parameter tSU = 5;        // min. Data In Setup Time
   parameter tH  = 5;        // min. Data In Hold Time 

   parameter tODV = 9;       // max. Output Valid from Clock Low
   parameter tOH  = 0;       // min. Output HOLD time
   parameter tOD  = 12;      // max. Output Disable Time

   parameter tHS = 10;       // min. HOLD Setup Time
   parameter tHH = 10;       // min. HOLD Hold Time
   parameter tLZ = 20;       // max. HOLD to Output Low Z
   parameter tHZ = 20;       // max. HOLD to Output High Z
   
`endif

`ifdef FM25V05
   `define addrBits 16
   `define Memblksize 65536
   `define TWO_BYTE_ADDR
   
   parameter Vddmax    =  3.6;      
   parameter hasWP = 1;
   parameter hasSleep = 1;  
   parameter hasDeviceid = 1;            
   parameter hasSN = 0;
   parameter tPU = 250000;     
   parameter tREC = 400000;
   parameter hasfastread = 1;               
   
   parameter addrBytes = 2;   

   parameter DEV_ID_MSB = 8'hC2;
   parameter DEV_ID_ISB = 8'h23;
   parameter DEV_ID_LSB = 8'h00;

   parameter fMAX  = 40;     // Max. frequency (Mz) 

   parameter tCH = 11;       // min. SCK High Time
   parameter tCL = 11;       // min. SCK LOw Time
 
   parameter tD   = 40;      // min. CS High Time
   parameter tCSU = 10;      // min. CS Setup Time
   parameter tCSH = 10;      // min. CS HOLD Time

   parameter tSU = 5;        // min. Data In Setup Time
   parameter tH  = 5;        // min. Data In Hold Time 

   parameter tODV = 9;       // max. Output Valid from Clock Low
   parameter tOH  = 0;       // min. Output HOLD time
   parameter tOD  = 12;      // max. Output Disable Time

   parameter tHS = 10;       // min. HOLD Setup Time
   parameter tHH = 10;       // min. HOLD Hold Time
   parameter tLZ = 20;       // max. HOLD to Output Low Z
   parameter tHZ = 20;       // max. HOLD to Output High Z
   
`endif

`ifdef FM25V02
   `define addrBits 15
   `define Memblksize 32768
   `define TWO_BYTE_ADDR
   
      
   parameter Vddmax    =  3.6;      
   parameter hasWP = 1;
   parameter hasSleep = 1;  
   parameter hasDeviceid = 1;            
   parameter hasSN = 0;
   parameter tPU = 250000;     
   parameter tREC = 400000;  
   parameter hasfastread = 1;               
   
   
   parameter addrBytes = 2;      
   
   parameter DEV_ID_MSB = 8'hC2;
   parameter DEV_ID_ISB = 8'h22;
   parameter DEV_ID_LSB = 8'h00;
   
   parameter fMAX  = 40;     // Max. frequency (Mz) 

   parameter tCH = 11;       // min. SCK High Time
   parameter tCL = 11;       // min. SCK LOw Time
 
   parameter tD   = 40;      // min. CS High Time
   parameter tCSU = 10;      // min. CS Setup Time
   parameter tCSH = 10;      // min. CS HOLD Time

   parameter tSU = 5;        // min. Data In Setup Time
   parameter tH  = 5;        // min. Data In Hold Time 

   parameter tODV = 9;       // max. Output Valid from Clock Low
   parameter tOH  = 0;       // min. Output HOLD time
   parameter tOD  = 12;      // max. Output Disable Time

   parameter tHS = 10;       // min. HOLD Setup Time
   parameter tHH = 10;       // min. HOLD Hold Time
   parameter tLZ = 20;       // max. HOLD to Output Low Z
   parameter tHZ = 20;       // max. HOLD to Output High Z
   
`endif

`ifdef FM25V02A
   `define addrBits 15
   `define Memblksize 32768
   `define TWO_BYTE_ADDR
   
      
   parameter Vddmax    =  3.6;      
   parameter hasWP = 1;
   parameter hasSleep = 1;  
   parameter hasDeviceid = 1;            
   parameter hasSN = 0;
   parameter tPU = 250000;     
   parameter tREC = 400000;  
   parameter hasfastread = 1;               
   
   
   parameter addrBytes = 2;      
   
   parameter DEV_ID_MSB = 8'hC2;
   parameter DEV_ID_ISB = 8'h22;
   parameter DEV_ID_LSB = 8'h08;
   
   parameter fMAX  = 40;     // Max. frequency (Mz) 

   parameter tCH = 11;       // min. SCK High Time
   parameter tCL = 11;       // min. SCK LOw Time
 
   parameter tD   = 40;      // min. CS High Time
   parameter tCSU = 10;      // min. CS Setup Time
   parameter tCSH = 10;      // min. CS HOLD Time

   parameter tSU = 5;        // min. Data In Setup Time
   parameter tH  = 5;        // min. Data In Hold Time 

   parameter tODV = 9;       // max. Output Valid from Clock Low
   parameter tOH  = 0;       // min. Output HOLD time
   parameter tOD  = 12;      // max. Output Disable Time

   parameter tHS = 10;       // min. HOLD Setup Time
   parameter tHH = 10;       // min. HOLD Hold Time
   parameter tLZ = 20;       // max. HOLD to Output Low Z
   parameter tHZ = 20;       // max. HOLD to Output High Z
   
`endif

`ifdef CY15B256Q
   `define addrBits 15
   `define Memblksize 32768
   `define TWO_BYTE_ADDR
   
      
   parameter Vddmax    =  3.6;      
   parameter hasWP = 1;
   parameter hasSleep = 1;  
   parameter hasDeviceid = 1;            
   parameter hasSN = 0;
   parameter tPU = 250000;     
   parameter tREC = 400000;
   parameter hasfastread = 1;                  
   
   parameter addrBytes = 2;   
   
   parameter DEV_ID_MSB = 8'hC2;
   parameter DEV_ID_ISB = 8'h22;
   parameter DEV_ID_LSB = 8'hC8; 
   
   parameter fMAX  = 40;     // Max. frequency (Mz) 

   parameter tCH = 11;       // min. SCK High Time
   parameter tCL = 11;       // min. SCK LOw Time
 
   parameter tD   = 40;      // min. CS High Time
   parameter tCSU = 10;      // min. CS Setup Time
   parameter tCSH = 10;      // min. CS HOLD Time

   parameter tSU = 5;        // min. Data In Setup Time
   parameter tH  = 5;        // min. Data In Hold Time 

   parameter tODV = 9;       // max. Output Valid from Clock Low
   parameter tOH  = 0;       // min. Output HOLD time
   parameter tOD  = 12;      // max. Output Disable Time

   parameter tHS = 10;       // min. HOLD Setup Time
   parameter tHH = 10;       // min. HOLD Hold Time
   parameter tLZ = 20;       // max. HOLD to Output Low Z
   parameter tHZ = 20;       // max. HOLD to Output High Z
   
`endif

`ifdef FM25V01
   `define addrBits 14
   `define Memblksize 16384
   `define TWO_BYTE_ADDR
   
      
   parameter Vddmax    =  3.6;      
   parameter hasWP = 1;
   parameter hasSleep = 1;  
   parameter hasDeviceid = 1;            
   parameter hasSN = 0;
   parameter tPU = 250000;     
   parameter tREC = 400000;
   parameter hasfastread = 1;                  
   
   parameter addrBytes = 2;   
   
   parameter DEV_ID_MSB = 8'hC2;
   parameter DEV_ID_ISB = 8'h21;
   parameter DEV_ID_LSB = 8'h00; 
   
   parameter fMAX  = 40;     // Max. frequency (Mz) 

   parameter tCH = 11;       // min. SCK High Time
   parameter tCL = 11;       // min. SCK LOw Time
 
   parameter tD   = 40;      // min. CS High Time
   parameter tCSU = 10;      // min. CS Setup Time
   parameter tCSH = 10;      // min. CS HOLD Time

   parameter tSU = 5;        // min. Data In Setup Time
   parameter tH  = 5;        // min. Data In Hold Time 

   parameter tODV = 9;       // max. Output Valid from Clock Low
   parameter tOH  = 0;       // min. Output HOLD time
   parameter tOD  = 12;      // max. Output Disable Time

   parameter tHS = 10;       // min. HOLD Setup Time
   parameter tHH = 10;       // min. HOLD Hold Time
   parameter tLZ = 20;       // max. HOLD to Output Low Z
   parameter tHZ = 20;       // max. HOLD to Output High Z
   
`endif

`ifdef FM25V01A
   `define addrBits 14
   `define Memblksize 16384
   `define TWO_BYTE_ADDR
   
      
   parameter Vddmax    =  3.6;      
   parameter hasWP = 1;
   parameter hasSleep = 1;  
   parameter hasDeviceid = 1;            
   parameter hasSN = 0;
   parameter tPU = 250000;     
   parameter tREC = 400000;
   parameter hasfastread = 1;                  
   
   parameter addrBytes = 2;   
   
   parameter DEV_ID_MSB = 8'hC2;
   parameter DEV_ID_ISB = 8'h21;
   parameter DEV_ID_LSB = 8'h08; 
   
   parameter fMAX  = 40;     // Max. frequency (Mz) 

   parameter tCH = 11;       // min. SCK High Time
   parameter tCL = 11;       // min. SCK LOw Time
 
   parameter tD   = 40;      // min. CS High Time
   parameter tCSU = 10;      // min. CS Setup Time
   parameter tCSH = 10;      // min. CS HOLD Time

   parameter tSU = 5;        // min. Data In Setup Time
   parameter tH  = 5;        // min. Data In Hold Time 

   parameter tODV = 9;       // max. Output Valid from Clock Low
   parameter tOH  = 0;       // min. Output HOLD time
   parameter tOD  = 12;      // max. Output Disable Time

   parameter tHS = 10;       // min. HOLD Setup Time
   parameter tHH = 10;       // min. HOLD Hold Time
   parameter tLZ = 20;       // max. HOLD to Output Low Z
   parameter tHZ = 20;       // max. HOLD to Output High Z
   
`endif

`ifdef CY15B128Q
   `define addrBits 14
   `define Memblksize 16384
   `define TWO_BYTE_ADDR
   
      
   parameter Vddmax    =  3.6;      
   parameter hasWP = 1;
   parameter hasSleep = 1;  
   parameter hasDeviceid = 1;            
   parameter hasSN = 0;
   parameter tPU = 250000;     
   parameter tREC = 400000;
   parameter hasfastread = 1;                  
   
   parameter addrBytes = 2;   
   
   parameter DEV_ID_MSB = 8'hC2;
   parameter DEV_ID_ISB = 8'h21;
   parameter DEV_ID_LSB = 8'h88; 
   
   parameter fMAX  = 40;     // Max. frequency (Mz) 

   parameter tCH = 11;       // min. SCK High Time
   parameter tCL = 11;       // min. SCK LOw Time
 
   parameter tD   = 40;      // min. CS High Time
   parameter tCSU = 10;      // min. CS Setup Time
   parameter tCSH = 10;      // min. CS HOLD Time

   parameter tSU = 5;        // min. Data In Setup Time
   parameter tH  = 5;        // min. Data In Hold Time 

   parameter tODV = 9;       // max. Output Valid from Clock Low
   parameter tOH  = 0;       // min. Output HOLD time
   parameter tOD  = 12;      // max. Output Disable Time

   parameter tHS = 10;       // min. HOLD Setup Time
   parameter tHH = 10;       // min. HOLD Hold Time
   parameter tLZ = 20;       // max. HOLD to Output Low Z
   parameter tHZ = 20;       // max. HOLD to Output High Z
   
`endif



`ifdef FM25CL64B
   `define addrBits 13
   `define Memblksize 8192
   `define TWO_BYTE_ADDR
   
      
   parameter Vddmax    =  3.65;      
   parameter hasWP = 1;
   parameter hasSleep = 0;  
   parameter hasDeviceid = 0;            
   parameter hasSN = 0;
   parameter tPU = 1000000;        
   parameter tREC = 0;  
   parameter hasfastread = 0;                     
 
   parameter addrBytes = 2;   

   parameter DEV_ID_MSB = 8'h00;
   parameter DEV_ID_ISB = 8'h00;
   parameter DEV_ID_LSB = 8'h00; 
   
   parameter fMAX  = 20;     // Max. frequency (Mz) 

   parameter tCH = 22;       // min. SCK High Time
   parameter tCL = 22;       // min. SCK LOw Time
 
   parameter tD   = 60;      // min. CS High Time
   parameter tCSU = 10;      // min. CS Setup Time
   parameter tCSH = 10;      // min. CS HOLD Time

   parameter tSU = 5;        // min. Data In Setup Time
   parameter tH  = 5;        // min. Data In Hold Time 

   parameter tODV = 20;       // max. Output Valid from Clock Low
   parameter tOH  = 0;       // min. Output HOLD time
   parameter tOD  = 20;      // max. Output Disable Time

   parameter tHS = 10;       // min. HOLD Setup Time
   parameter tHH = 10;       // min. HOLD Hold Time
   parameter tLZ = 20;       // max. HOLD to Output Low Z
   parameter tHZ = 20;       // max. HOLD to Output High Z
   
`endif

`ifdef FM25L16B
   `define addrBits 11
   `define Memblksize 2048
   `define TWO_BYTE_ADDR
   
      
   parameter Vddmax    =  3.6;      
   parameter hasWP = 1;
   parameter hasSleep = 0;  
   parameter hasDeviceid = 0;            
   parameter hasSN = 0;
   parameter tPU = 1000000;           
   parameter tREC = 0;   
   parameter hasfastread = 0;                     

   parameter addrBytes = 2;
   
   parameter DEV_ID_MSB = 8'h00;
   parameter DEV_ID_ISB = 8'h00;
   parameter DEV_ID_LSB = 8'h00;

   parameter fMAX  = 20;     // Max. frequency (Mz) 

   parameter tCH = 22;       // min. SCK High Time
   parameter tCL = 22;       // min. SCK LOw Time
 
   parameter tD   = 60;      // min. CS High Time
   parameter tCSU = 10;      // min. CS Setup Time
   parameter tCSH = 10;      // min. CS HOLD Time

   parameter tSU = 5;        // min. Data In Setup Time
   parameter tH  = 5;        // min. Data In Hold Time 

   parameter tODV = 20;       // max. Output Valid from Clock Low
   parameter tOH  = 0;       // min. Output HOLD time
   parameter tOD  = 20;      // max. Output Disable Time

   parameter tHS = 10;       // min. HOLD Setup Time
   parameter tHH = 10;       // min. HOLD Hold Time
   parameter tLZ = 20;       // max. HOLD to Output Low Z
   parameter tHZ = 20;       // max. HOLD to Output High Z
   
`endif

`ifdef FM25L04B
   `define addrBits 9
   `define Memblksize 512
   `define ONE_BYTE_ADDR
   
      
   parameter Vddmax    =  3.6;      
   parameter hasWP = 1;
   parameter hasSleep = 0;  
   parameter hasDeviceid = 0;            
   parameter hasSN = 0;
   parameter tPU = 1000000;              
   parameter tREC = 0;   
   parameter hasfastread = 0;                        

   parameter addrBytes = 1;   
   
   parameter DEV_ID_MSB = 8'h00;
   parameter DEV_ID_ISB = 8'h00;
   parameter DEV_ID_LSB = 8'h00;  
   
   parameter fMAX  = 20;     // Max. frequency (Mz) 

   parameter tCH = 22;       // min. SCK High Time
   parameter tCL = 22;       // min. SCK LOw Time
 
   parameter tD   = 60;      // min. CS High Time
   parameter tCSU = 10;      // min. CS Setup Time
   parameter tCSH = 10;      // min. CS HOLD Time

   parameter tSU = 5;        // min. Data In Setup Time
   parameter tH  = 5;        // min. Data In Hold Time 

   parameter tODV = 20;       // max. Output Valid from Clock Low
   parameter tOH  = 0;       // min. Output HOLD time
   parameter tOD  = 20;      // max. Output Disable Time

   parameter tHS = 10;       // min. HOLD Setup Time
   parameter tHH = 10;       // min. HOLD Hold Time
   parameter tLZ = 20;       // max. HOLD to Output Low Z
   parameter tHZ = 20;       // max. HOLD to Output High Z
   
`endif

`ifdef FM25640B
   `define addrBits 13
   `define Memblksize 8192
   `define TWO_BYTE_ADDR
   
      
   parameter Vddmax    =  5.5;      
   parameter hasWP = 1;
   parameter hasSleep = 0;  
   parameter hasDeviceid = 0;            
   parameter hasSN = 0;
   parameter tPU = 1000000;                 
   parameter tREC = 0;
   parameter hasfastread = 0;                           

   parameter addrBytes = 2;   

   parameter DEV_ID_MSB = 8'h00;
   parameter DEV_ID_ISB = 8'h00;
   parameter DEV_ID_LSB = 8'h00;   
   
   parameter fMAX  = 20;     // Max. frequency (Mz) 

   parameter tCH = 22;       // min. SCK High Time
   parameter tCL = 22;       // min. SCK LOw Time
 
   parameter tD   = 60;      // min. CS High Time
   parameter tCSU = 10;      // min. CS Setup Time
   parameter tCSH = 10;      // min. CS HOLD Time

   parameter tSU = 5;        // min. Data In Setup Time
   parameter tH  = 5;        // min. Data In Hold Time 

   parameter tODV = 20;       // max. Output Valid from Clock Low
   parameter tOH  = 0;       // min. Output HOLD time
   parameter tOD  = 20;      // max. Output Disable Time

   parameter tHS = 10;       // min. HOLD Setup Time
   parameter tHH = 10;       // min. HOLD Hold Time
   parameter tLZ = 20;       // max. HOLD to Output Low Z
   parameter tHZ = 20;       // max. HOLD to Output High Z
   
`endif


`ifdef FM25C160B
   `define addrBits 11
   `define Memblksize 2048
   `define TWO_BYTE_ADDR
   
      
   parameter Vddmax    =  5.5;      
   parameter hasWP = 1;
   parameter hasSleep = 0;  
   parameter hasDeviceid = 0;            
   parameter hasSN = 0;
   parameter tPU = 1000000;                    
   parameter tREC = 0;   
   parameter hasfastread = 0;                           

   parameter addrBytes = 2;   

   parameter DEV_ID_MSB = 8'h00;
   parameter DEV_ID_ISB = 8'h00;
   parameter DEV_ID_LSB = 8'h00;   
   
   parameter fMAX  = 20;     // Max. frequency (Mz) 

   parameter tCH = 22;       // min. SCK High Time
   parameter tCL = 22;       // min. SCK LOw Time
 
   parameter tD   = 60;      // min. CS High Time
   parameter tCSU = 10;      // min. CS Setup Time
   parameter tCSH = 10;      // min. CS HOLD Time

   parameter tSU = 5;        // min. Data In Setup Time
   parameter tH  = 5;        // min. Data In Hold Time 

   parameter tODV = 20;       // max. Output Valid from Clock Low
   parameter tOH  = 0;       // min. Output HOLD time
   parameter tOD  = 20;      // max. Output Disable Time

   parameter tHS = 10;       // min. HOLD Setup Time
   parameter tHH = 10;       // min. HOLD Hold Time
   parameter tLZ = 20;       // max. HOLD to Output Low Z
   parameter tHZ = 20;       // max. HOLD to Output High Z
   
`endif

`ifdef FM25040B
   `define addrBits 9
   `define Memblksize 512
   `define ONE_BYTE_ADDR
   

   parameter Vddmax    =  5.5;      
   parameter hasWP = 1;
   parameter hasSleep = 0;  
   parameter hasDeviceid = 0;            
   parameter hasSN = 0;
   parameter tPU = 1000000;                       
   parameter tREC = 0;   
   parameter hasfastread = 0;                           

   parameter addrBytes = 1;   

   parameter DEV_ID_MSB = 8'h00;
   parameter DEV_ID_ISB = 8'h00;
   parameter DEV_ID_LSB = 8'h00;   
   
   parameter fMAX  = 20;     // Max. frequency (Mz) 

   parameter tCH = 22;       // min. SCK High Time
   parameter tCL = 22;       // min. SCK LOw Time
 
   parameter tD   = 60;      // min. CS High Time
   parameter tCSU = 10;      // min. CS Setup Time
   parameter tCSH = 10;      // min. CS HOLD Time

   parameter tSU = 5;        // min. Data In Setup Time
   parameter tH  = 5;        // min. Data In Hold Time 

   parameter tODV = 20;       // max. Output Valid from Clock Low
   parameter tOH  = 0;       // min. Output HOLD time
   parameter tOD  = 20;      // max. Output Disable Time

   parameter tHS = 10;       // min. HOLD Setup Time
   parameter tHH = 10;       // min. HOLD Hold Time
   parameter tLZ = 20;       // max. HOLD to Output Low Z
   parameter tHZ = 20;       // max. HOLD to Output High Z
   
`endif

`ifdef FM25W256
   `define addrBits 15
   `define Memblksize 32768
   `define TWO_BYTE_ADDR
   
      
   parameter Vddmax    =  5.5;      
   parameter hasWP = 1;
   parameter hasSleep = 0;  
   parameter hasDeviceid = 0;            
   parameter hasSN = 0;
   parameter tPU = 1000000;                          
   parameter tREC = 0;
   parameter hasfastread = 0;                              

   parameter addrBytes = 2;   

   parameter DEV_ID_MSB = 8'h00;
   parameter DEV_ID_ISB = 8'h00;
   parameter DEV_ID_LSB = 8'h00; 
   
   parameter fMAX  = 20;     // Max. frequency (Mz) 

   parameter tCH = 22;       // min. SCK High Time
   parameter tCL = 22;       // min. SCK LOw Time
 
   parameter tD   = 60;      // min. CS High Time
   parameter tCSU = 10;      // min. CS Setup Time
   parameter tCSH = 10;      // min. CS HOLD Time

   parameter tSU = 5;        // min. Data In Setup Time
   parameter tH  = 5;        // min. Data In Hold Time 

   parameter tODV = 20;      // max. Output Valid from Clock Low
   parameter tOH  = 0;       // min. Output HOLD time
   parameter tOD  = 20;      // max. Output Disable Time

   parameter tHS = 10;       // min. HOLD Setup Time
   parameter tHH = 10;       // min. HOLD Hold Time
   parameter tLZ = 20;       // max. HOLD to Output Low Z
   parameter tHZ = 25;       // max. HOLD to Output High Z
   
`endif

//_______________________________________________________________________
//  Uncomment only if you want to initialize memory with values from a file
//
//`define       initMemFile     "init.dat"

// Code your testbench here
// or browse Examples
module MD5;
    string inStr = "";
  reg unsigned [7:0] array1[];
  reg unsigned [7:0] array2[];
  reg unsigned [63:0] size = 0;
  reg unsigned [63:0] sizeSingle = 0;
  reg unsigned [7:0] rotateA [0:7];
  reg unsigned [31:0] wordA = 32'h 01234567;
  reg unsigned [31:0] wordB = 32'h 89abcdef;
  reg unsigned [31:0] wordC = 32'h fedcba98;
  reg unsigned [31:0] wordD = 32'h 76543210;
  
  reg unsigned [7:0] tempNum = 0;
  
  reg unsigned [15:0] sizeS = 0;
  reg unsigned [5:0] modulo64 = 0;
  reg unsigned [1:0] modulo4 = 0;
  
  reg unsigned [31:0] tableConst = '{
     0xd76aa478, 0xe8c7b756, 0x242070db, 0xc1bdceee,

     0xf57c0faf, 0x4787c62a, 0xa8304613, 0xfd469501,
   
     0x698098d8, 0x8b44f7af, 0xffff5bb1, 0x895cd7be,
   
     0x6b901122, 0xfd987193, 0xa679438e, 0x49b40821,
   
     0xf61e2562, 0xc040b340, 0x265e5a51, 0xe9b6c7aa,
   
     0xd62f105d, 0x02441453, 0xd8a1e681, 0xe7d3fbc8,
   
     0x21e1cde6, 0xc33707d6, 0xf4d50d87, 0x455a14ed,

     0xa9e3e905, 0xfcefa3f8, 0x676f02d9, 0x8d2a4c8a,

     0xfffa3942, 0x8771f681, 0x6d9d6122, 0xfde5380c,

     0xa4beea44, 0x4bdecfa9, 0xf6bb4b60, 0xbebfbc70,

     0x289b7ec6, 0xeaa127fa, 0xd4ef3085, 0x04881d05,

     0xd9d4d039, 0xe6db99e5, 0x1fa27cf8, 0xc4ac5665,

     0xf4292244, 0x432aff97, 0xab9423a7, 0xfc93a039,

     0x655b59c3, 0x8f0ccc92, 0xffeff47d, 0x85845dd1,

     0x6fa87e4f, 0xfe2ce6e0, 0xa3014314, 0x4e0811a1,

     0xf7537e82, 0xbd3af235, 0x2ad7d2bb, 0xeb86d391};

     
  
  initial begin
    
    inStr = "abcdefghijklmnopqrstuvwxyz";
    size = inStr.len();
    
    modulo64[5:0] = size[5:0];
    sizeS = size >> 6;
    
    $display("Size of input: %d", size);
    
    if (modulo64 < 56)
      begin
        // extend array to nearest 64 bytes
        array1 = new[(64 * sizeS) + 64 - sizeS];
      end
    
    else 
      begin
        tempNum[5:0] = size[5:0];
         
        
        //extend array to nearest 64 bytes then append 64 more
        array1 = new[64 - tempNum + (64 * (sizeS + 1)) + size];
      end
    
    for (int i = 0; i < array1.size(); i++)
      begin
        array1[i] = 0;
      end
    
    
    /*for (int i = 0; i < size; i++)
      begin
        array1[i] = {inStr[i]};
      end    */
    
    for (int i = 1; i < (size >> 2) + 2; i++)
      begin
        for (int j = 1; j <= 4; j++)
          begin
            array1[(i*4) - (5-j)] = {inStr[((i-1)*4) + (4-j)]};
          end
      end
    

    
    //append '128' i.e 1000 000 to the beginning of the last filled block
    modulo4[1:0] = size[1:0];
    
    if (modulo4 != 0)
      begin
        array1[(((size >> 2) + 1) * 4) - (4 - modulo4) - 1] = 128;
      end
    else
      begin
        array1[(((size >> 2) + 1) * 4) - 1] = 128;
      end        
    $display("append place: %d", ((((size >> 2) + 1) * 4) - (4 - modulo4) - 1));
    

    
    //append the length of the original message in bits to the last 8 bits
    size = size * 8;
    for (int i = 0; i < 2; i++)
      begin
        for (int j = 1; j <= 4; j++)
          begin
            sizeSingle[7:0] = size[7:0];
            size = size >> 8;
            rotateA[i*4 + (j-1)] = sizeSingle;
          end
      end
    
    
    
    /*for (int i = 0; i > 6; i--)
      begin
        if (rotateA[i] != 0)
          begin
            $display(rotateA[i+1], " is now ", rotateA[i]);
            rotateA[i+1] = rotateA[i];
          end 
      end*/
    
    if ((rotateA[1]||rotateA[2]||rotateA[3]||rotateA[4]||rotateA[5]||rotateA[6]||rotateA[7]))
      begin
        for (int i = 0; i < 6; i++)
          begin
            if (tempNum == 0)
              begin
                tempNum = rotateA[7];
                rotateA[7] = rotateA[6];
                rotateA[6] = rotateA[5];
                rotateA[5] = rotateA[4];
                rotateA[4] = rotateA[3];
                rotateA[3] = rotateA[2];
                rotateA[2] = rotateA[1];
                rotateA[1] = rotateA[0];
                rotateA[0] = tempNum;
              end
          end
      end
    else
      begin
        rotateA[7] = rotateA[0];
        rotateA[0] = 0;
      end
      
          

        
    for (int i = 0; i <= 7; i++)
      begin
        $display(rotateA[i]);
      end
    
    
    for (int i = 0; i < 2; i++)
      begin
        for (int j = 1; j <= 4; j++)
          begin
            array1[array1.size() - (2-i) * 4 + (4-j)] = rotateA[7-(i*4 + (j-1))];
          end
      end
    
    /*for (int i = 0; i < array1.size(); i++)
      begin
        $write("Index: %d", i, "\t %h", array1[i]);
      end*/   
    
    for (int i = 0; i < (array1.size() >> 2); i++)
      begin
        $write("I %0d", (i * 4), " to %0d", (i + 1)*4 - 1, ":\t\t\t");
        for (int j = 0; j < 4; j++)
          begin
            $write("%h", array1[i*4 + j], " ");
          end
        $display();
      end
    
    
    
    
  end
endmodule
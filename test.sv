// Code your testbench here
// or browse Examples
module MD5;
    string inStr = "";
  reg unsigned [7:0] array1[];
  reg unsigned [7:0] array2[];
  reg unsigned [63:0] size = 0;
  reg unsigned [63:0] sizeSingle = 0;
  reg unsigned [7:0] rotateA [0:7];
  reg unsigned [31:0] wordA = 32'h 67452301;
  reg unsigned [31:0] wordB = 32'h EFCDAB89;
  reg unsigned [31:0] wordC = 32'h 98BADCFE;
  reg unsigned [31:0] wordD = 32'h 10325476;
  
  reg unsigned [7:0] tempNum = 0;
  
  reg unsigned [15:0] sizeS = 0;
  reg unsigned [5:0] modulo64 = 0;
  reg unsigned [1:0] modulo4 = 0;
  
  //reg unsigned [31:0] constTable[];
  reg unsigned [31:0] changeValue;

  //reg unsigned [31:0] constTable[1:0] = {'he8c7b756, 'hd76aa478};
  
  reg unsigned [31:0] constTable[63:0] = '{
    'heb86d391, 'h2ad7d2bb, 'hbd3af235, 'hf7537e82,
    'h4e0811a1, 'ha3014314, 'hfe2ce6e0, 'h6fa87e4f,
    'h85845dd1, 'hffeff47d, 'h8f0ccc92, 'h655b59c3,
    'hfc93a039, 'hab9423a7, 'h432aff97, 'hf4292244,
    'hc4ac5665, 'h1fa27cf8, 'he6db99e5, 'hd9d4d039,
    'h04881d05, 'hd4ef3085, 'heaa127fa, 'h289b7ec6,
    'hbebfbc70, 'hf6bb4b60, 'h4bdecfa9, 'ha4beea44,
    'hfde5380c, 'h6d9d6122, 'h8771f681, 'hfffa3942,
    'h8d2a4c8a, 'h676f02d9, 'hfcefa3f8, 'ha9e3e905,
    'h455a14ed, 'hf4d50d87, 'hc33707d6, 'h21e1cde6,
    'he7d3fbc8, 'hd8a1e681, 'h02441453, 'hd62f105d,
    'he9b6c7aa, 'h265e5a51, 'hc040b340, 'hf61e2562,
    'h49b40821, 'ha679438e, 'hfd987193, 'h6b901122,
    'h895cd7be, 'hffff5bb1, 'h8b44f7af, 'h698098d8,
    'hfd469501, 'ha8304613, 'h4787c62a, 'hf57c0faf,
    'hc1bdceee, 'h242070db, 'he8c7b756, 'hd76aa478
    };
     

        function int F(reg unsigned [31:0] X, Y, Z);
          return ((X & Y) | ((~X) & Z));
        endfunction

      
        function int G(reg unsigned [31:0] X, Y, Z);
          return ((X & Z) | (Y & (~Z)));  
        endfunction

      
        function int H(reg unsigned [31:0] X, Y, Z);
            return (X^Y^Z);  
        endfunction

        
        function int I(reg unsigned [31:0] X, Y, Z);
          return (Y ^ (X | (~Z)));  
        endfunction

        
        function automatic void R1(ref reg unsigned [31:0] a, b, c, d, reg unsigned [31:0] x, s, n);
          changeValue = (a + F(b,c,d) + x + constTable[n]);
          a = b + leftRotate(changeValue, s);
          n++;
        endfunction


        function automatic void R2(ref reg unsigned [31:0] a, b, c, d, reg unsigned [31:0] x, s, n);
          changeValue = (a + G(b,c,d) + x + constTable[n]);
          a = b + leftRotate(changeValue, s);
          n++;
        endfunction


        function automatic void R3(ref reg unsigned [31:0] a, b, c, d, reg unsigned [31:0] x, s, n);
          changeValue = (a + H(b,c,d) + x + constTable[n]);
          a = b + leftRotate(changeValue, s);
          n++;
        endfunction


        function automatic void R4(ref reg unsigned [31:0] a, b, c, d, reg unsigned [31:0] x, s, n);
          changeValue = (a + I(b,c,d) + x + constTable[n]);
          a = b + leftRotate(changeValue, s);
          n++;
        endfunction


        function reg unsigned [31:0] leftRotate(reg unsigned [31:0] x, y);
          for (int i = 0; i < y; i++)
            begin
              x = (x << 1 | x >> 31);
            end
          return x;
        endfunction


        //function reg unsigned [63:0] MD5;
  function automatic void MD5(ref reg unsigned [31:0] a,b,c,d);
          //input reg unsigned [7:0] x[];
          //input reg unsigned [15:0] s, i;
          static reg unsigned [31:0] x = 31'h00000080;
          static reg unsigned [31:0] y = 0;
          static reg unsigned [31:0] s, n;
          s = 7;
          n = 0;
   

          //R1(a,b,c,d,x[0],7,1);
    
    
    
          /*R1(a,b,c,d,x,s,n);
          s += 5;
          R1(d,a,b,c,y,s,n);
          s += 5;
          R1(c,d,a,b,y,s,n);
          s += 5;
          R1(b,c,d,a,y,s,n);*/


          for (int i = 0; i < 4; i++)
            begin
              case (i)
                0:begin
                  s = 7; 
                  R1(a,b,c,d,x,s,n);
                end
                1:begin
                  s = 12; 
                  R1(d,a,b,c,y,s,n);
                end
                2:begin
                  s = 17;  
                  R1(c,d,a,b,y,s,n);
                end
                3:begin
                  s = 22; 
                  R1(b,c,d,a,y,s,n);
                end
                default: $display("case select error");
              endcase
            end

            for (int i = 0; i < 4; i++)
            begin
              case (i)
                0:begin
                  s = 7; 
                  R1(a,b,c,d,x,s,n);
                end
                1:begin
                  s = 12; 
                  R1(d,a,b,c,y,s,n);
                end
                2:begin
                  s = 17;  
                  R1(c,d,a,b,y,s,n);
                end
                3:begin
                  s = 22; 
                  R1(b,c,d,a,y,s,n);
                end
                default: $display("case select error");
              endcase
            end

            for (int i = 0; i < 4; i++)
            begin
              case (i)
                0:begin
                  s = 7; 
                  R1(a,b,c,d,x,s,n);
                end
                1:begin
                  s = 12; 
                  R1(d,a,b,c,y,s,n);
                end
                2:begin
                  s = 17;  
                  R1(c,d,a,b,y,s,n);
                end
                3:begin
                  s = 22; 
                  R1(b,c,d,a,y,s,n);
                end
                default: $display("case select error");
              endcase
            end

            for (int i = 0; i < 4; i++)
            begin
              case (i)
                0:begin
                  s = 7; 
                  R1(a,b,c,d,x,s,n);
                end
                1:begin
                  s = 12; 
                  R1(d,a,b,c,y,s,n);
                end
                2:begin
                  s = 17;  
                  R1(c,d,a,b,y,s,n);
                end
                3:begin
                  s = 22; 
                  R1(b,c,d,a,y,s,n);
                end
                default: $display("case select error");
              endcase
            end
          


          

           /*a += wordA;
          b += wordB;
          c += wordC;
          d += wordD;*/


          $display("a: %h", a);
          $display("b: %h", b);
          $display("c: %h", c);
          $display("d: %h", d);
        endfunction
  
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

    
    for (int i = 0; i < (array1.size() >> 2); i++)
      begin
        $write("I %0d", (i * 4), " to %0d", (i + 1)*4 - 1, ":\t\t\t");
        for (int j = 0; j < 4; j++)
          begin
            $write("%h", array1[i*4 + j], " ");
          end
        $display();
      end
         
    
    MD5(wordA, wordB, wordC, wordD);
  end
endmodule
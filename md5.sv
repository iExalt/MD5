// Code your testbench here
// or browse Examples
module MD5;
  //string inStr = "abcdefghijklmnopqrstuvwxyz";
  string inStr = "abc";
  reg unsigned [7:0] array1[];
  reg unsigned [31:0] array2[];
  reg unsigned [31:0] array3 [15:0];
  reg unsigned [63:0] size = 0;
  reg unsigned [63:0] sizeSingle = 0;
  reg unsigned [7:0] rotateByte [0:7];
  reg unsigned [7:0] rotateA [0:3];
  reg unsigned [7:0] rotateB [0:3];
  reg unsigned [7:0] rotateC [0:3];
  reg unsigned [7:0] rotateD [0:3];
  reg unsigned [31:0] wordA = 32'h 67452301;
  reg unsigned [31:0] wordB = 32'h EFCDAB89;
  reg unsigned [31:0] wordC = 32'h 98BADCFE;
  reg unsigned [31:0] wordD = 32'h 10325476;
  reg unsigned [31:0] tempA = 0;
  reg unsigned [31:0] tempB = 0;
  reg unsigned [31:0] tempC = 0;
  reg unsigned [31:0] tempD = 0;
  reg unsigned [31:0] resultA = 32'h 67452301;
  reg unsigned [31:0] resultB = 32'h EFCDAB89;
  reg unsigned [31:0] resultC = 32'h 98BADCFE;
  reg unsigned [31:0] resultD = 32'h 10325476;
  
  reg unsigned [7:0] tempNum = 0;
  
  reg unsigned [15:0] sizeS = 0;
  reg unsigned [5:0] modulo64 = 0;
  reg unsigned [1:0] modulo4 = 0;
  
  reg unsigned [31:0] changeValue = 0;
  
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
  function automatic void MD5(reg unsigned [31:0] x[], ref reg unsigned [31:0] a,b,c,d);
          static reg unsigned [31:0] s, n, message, o, dispA, dispB, dispC, dispD = 0;
          s = 7;
          n = 0;

          a = wordA;
          b = wordB;
          c = wordC;
          d = wordD;   



          //first round
          for (int i = 0; i < 4; i++)
            begin
              for (int j = 0; j < 4; j++)
                begin
                  message = x[n];
                  case (j)
                    0:begin
                      s = 7; 
                      R1(a,b,c,d,message,s,n);
                    end
                    1:begin
                      s = 12; 
                      R1(d,a,b,c,message,s,n);
                    end
                    2:begin
                      s = 17;
                      R1(c,d,a,b,message,s,n);
                    end
                    3:begin
                      s = 22; 
                      R1(b,c,d,a,message,s,n);
                    end
                    default: $display("case select error");
                  endcase
                  /*$display("Round: %0d", i * 4 + j);
                  $display("A: %h", a);
                  $display("B: %h", b);
                  $display("C: %h", c);
                  $display("D: %h", d);
                  $display("s: %d", s);
                  $display("n: %d", n);
                  $display("Message: %h", message);*/

                end
            end


            //second round
            o = 1;
            for (int i = 0; i < 4; i++)
            begin
              for (int j = 0; j < 4; j++)
                begin
                  message = x[o];
                  case (j)
                    0:begin
                      s = 5; 
                      R2(a,b,c,d,message,s,n);
                    end
                    1:begin
                      s = 9; 
                      R2(d,a,b,c,message,s,n);
                    end
                    2:begin
                      s = 14;  
                      R2(c,d,a,b,message,s,n);
                    end
                    3:begin
                      s = 20; 
                      R2(b,c,d,a,message,s,n);
                    end
                    default: $display("case select error");
                  endcase

                  o += 5;
                  if (o >= 16) 
                    begin
                      o -= 16;
                    end
                 
                end
            end


            //third round
            o = 5;
            for (int i = 0; i < 4; i++)
            begin
              for (int j = 0; j < 4; j++)
                begin
                  message = x[o];
                  case (j)
                    0:begin
                      s = 4; 
                      R3(a,b,c,d,message,s,n);
                    end
                    1:begin
                      s = 11; 
                      R3(d,a,b,c,message,s,n);
                    end
                    2:begin
                      s = 16;  
                      R3(c,d,a,b,message,s,n);
                    end
                    3:begin
                      s = 23; 
                      R3(b,c,d,a,message,s,n);
                    end
                    default: $display("case select error");
                  endcase

                  o += 3;
                  if (o >= 16) 
                    begin
                      o -= 16;
                    end             
                end
            end


            //fourth round
            o = 0;
            for (int i = 0; i < 4; i++)
            begin
              for (int j = 0; j < 4; j++)
                begin
                  message = x[o];
                  case (j)
                    0:begin
                      s = 6; 
                      R4(a,b,c,d,message,s,n);
                    end
                    1:begin
                      s = 10; 
                      R4(d,a,b,c,message,s,n);
                    end
                    2:begin
                      s = 15;  
                      R4(c,d,a,b,message,s,n);
                    end
                    3:begin
                      s = 21; 
                      R4(b,c,d,a,message,s,n);
                    end
                    default: $display("case select error");
                  endcase

                  o += 7;
                  if (o >= 16) 
                    begin
                      o -= 16;
                    end             
                end
            end


          a += wordA;
          b += wordB;
          c += wordC;
          d += wordD;
          
          wordA = a;
          wordB = b;
          wordC = c;
          wordD = d;

          $display("wordA %h", wordA);

          for (int i = 0; i < 4; i++)
            begin
              rotateA[i] = a[7:0];
              rotateB[i] = b[7:0];
              rotateC[i] = c[7:0];
              rotateD[i] = d[7:0];
              a = a >> 8;
              b = b >> 8;
              c = c >> 8;
              d = d >> 8;
            end

          dispA = {rotateA[0], rotateA[1], rotateA[2], rotateA[3]};
          dispB = {rotateB[0], rotateB[1], rotateB[2], rotateB[3]};
          dispC = {rotateC[0], rotateC[1], rotateC[2], rotateC[3]};
          dispD = {rotateD[0], rotateD[1], rotateD[2], rotateD[3]};

          $display("");
          $display("");
          $display("Final output: %h", {dispA,dispB,dispC,dispD});
          $display("Size: ", array1.size());
          


        endfunction
  
  initial begin


    


    

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
    //extend array2 to the same size as array1
    size = inStr.len();
    array2 = new[array1.size() >> 2];

    
    //append '128' i.e 1000 000 to the beginning of the last filled block
    modulo4 = size[1:0];
    
    if (modulo4 != 0)
      begin
        array1[((size >> 2) * 4) + (3 - modulo4)] = 128;
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
            rotateByte[i*4 + (j-1)] = sizeSingle;
          end
      end
    
    /*tempNum = 0;
    if ((rotateByte[1]||rotateByte[2]||rotateByte[3]||rotateByte[4]||rotateByte[5]||rotateByte[6]||rotateByte[7]))
      begin
        for (int i = 0; i < 6; i++)
          begin
            if (tempNum == 0)
              begin
                tempNum = rotateByte[7];
                rotateByte[7] = rotateByte[6];
                rotateByte[6] = rotateByte[5];
                rotateByte[5] = rotateByte[4];
                rotateByte[4] = rotateByte[3];
                rotateByte[3] = rotateByte[2];
                rotateByte[2] = rotateByte[1];
                rotateByte[1] = rotateByte[0];
                rotateByte[0] = tempNum;
              end
          end
      end
    else
      begin
        rotateByte[7] = rotateByte[0];
        rotateByte[0] = 0;
      end
    */
         
    
    for (int i = 0; i < 2; i++)
      begin
        for (int j = 1; j <= 4; j++)
          begin
             //array1[array1.size() - (2-i) * 4 + (4-j)] = rotateByte[7-(i*4 + (j-1))];
             array1[array1.size() - (2-i) * 4 + (4-j)] = rotateByte[(i*4 + (j-1))];
          end
      end

    
    for (int i = 0; i < (array1.size() >> 2); i++)
      begin
        array2[i] = {array1[i*4], array1[i*4 + 1], array1[i*4 + 2], array1[i*4 + 3]};


        $write("I %0d", (i * 4), " to %0d", (i + 1)*4 - 1, ":\t\t\t");
        for (int j = 0; j < 4; j++)
          begin
            $write("%h", array1[i*4 + j], " ");
          end
        $display();
      end
         
      for (int i = 0; i < array2.size(); i++)
        begin
          $display("newArray[ %d", i, "] = %h", array2[i]);
        end

    for (int i = 0; i < (array1.size() >> 6); i++)
      begin
        array3 = array2[0:15];
        MD5(array3, resultA, resultB, resultC, resultD);        
        for (int j = 0; j < array2.size(); j++)
          begin
            array2[j] = array2[j+16];
            //$display("array2[ %d", j, "] = %h", array2[i]);
          end
      end

  end
endmodule
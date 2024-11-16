
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity lut_4_2 is
    Port ( 
        A : in STD_LOGIC;
        B : in STD_LOGIC;
        C : in STD_LOGIC;
        D : in STD_LOGIC;
        Q : out STD_LOGIC
    );
end lut_4_2;

architecture Behavioral of lut_4_2 is
begin
    process(A, B, C, D)
    begin
        Q <= ((not A) and (not B) and (C) and (not D)) or
             ((not A) and (not B) and (C) and (D)) or
             ((not A) and (B) and (not C) and (D)) or
             ((not A) and (B) and (C) and (not D)) or
             ((A) and (B) and (C) and (D));
    end process;
end Behavioral;

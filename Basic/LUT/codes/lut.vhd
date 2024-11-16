library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity lut4 is
    Port (
        A : in STD_LOGIC;
        B : in STD_LOGIC;
        C : in STD_LOGIC;
        D : in STD_LOGIC;
        Q : out STD_LOGIC
    );
end lut4;

architecture Behavioral of lut4 is
begin
    process (A, B, C, D)
    begin
        case (A & B & C & D) is
            when "0000" => Q <= '0';
            when "0001" => Q <= '0';
            when "0010" => Q <= '1';
            when "0011" => Q <= '1';
            when "0100" => Q <= '0';
            when "0101" => Q <= '1';
            when "0110" => Q <= '1';
            when "0111" => Q <= '0';
            when "1000" => Q <= '0';
            when "1001" => Q <= '0';
            when "1010" => Q <= '0';
            when "1011" => Q <= '0';
            when "1100" => Q <= '0';
            when "1101" => Q <= '0';
            when "1110" => Q <= '0';
            when "1111" => Q <= '1';
            when others => Q <= null;
        end case;
    end process;
end Behavioral;

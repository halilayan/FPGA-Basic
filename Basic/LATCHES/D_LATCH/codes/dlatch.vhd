


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;


entity dlatch is
    Port ( D_i 		: in STD_LOGIC;
           E_i 		: in STD_LOGIC;
           clk_i 	: in STD_LOGIC;
           rst_i 	: in STD_LOGIC;
           Q_o 		: out STD_LOGIC
           );
end dlatch;

architecture Behavioral of dlatch is

begin
	process (clk_i, D_i, E_i)
		variable DE_i	: std_logic_vector (1 downto 0);
		variable latch	: std_logic:='0';
		variable cikis	: std_logic;
		
		begin
			DE_i:= D_i & E_i;
			
				if (rst_i = '1') then 
					Q_o <= '0';
				elsif rising_edge (clk_i) then
				    case DE_i is
					   when "00" => cikis := latch;
					   when "01" => cikis := latch;
					   when "10" => cikis := '0';
					   when "11" => cikis := '1';
					   when others => null;
			        end case;	
	           end if;			   
		Q_o <= cikis;
	end process;
end Behavioral;

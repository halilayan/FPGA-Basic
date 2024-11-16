


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;


entity jk is
	port(
			J_i 	: in std_logic;
			K_i 	: in std_logic;
			clk_i 	: in std_logic;
			rst_i	: in std_logic;
			Q_o 	: out std_logic
		);
	end jk;

architecture Behavioral of jk is
	signal s_Q_int	: std_logic := '0';

begin
	process (clk_i, rst_i)
	begin
		if (rst_i = '1') then
			s_Q_int <= '0';
		elsif rising_edge (clk_i) then
			s_Q_int <= '0' when (J_i = '0' and K_i = '1') else
					'1' when (J_i = '1' and K_i = '0') else
					not s_Q_int when (J_i = '1' and K_i = '1') else
					s_Q_int;		 
		end if;
	end process;
	Q_o <= s_Q_int;
	
end Behavioral;

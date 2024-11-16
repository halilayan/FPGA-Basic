library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity register_16bit is
    Port (
        clk   	  : in  std_logic;   
        rst   	  : in  std_logic;   
        en_i      : in  std_logic;   
        d_i       : in  std_logic_vector(7 downto 0); 
        q_o       : out std_logic_vector(15 downto 0) 
    );
end register_16bit;

architecture Behavioral of register_16bit is
    signal s_reg_data : std_logic_vector(15 downto 0) := (others => '0'); 
    signal s_state    : std_logic := '0'; 
begin
    process (clk, rst)
    begin      
        if rst = '1' then
            s_reg_data <= (others => '0'); 
            s_state <= '0'; 
        elsif rising_edge(clk) then
            if en_i = '1' then
                if s_state = '0' then         
                    s_reg_data(7 downto 0) <= d_i;
                    s_state <= '1'; 
                else                   
                    s_reg_data(15 downto 8) <= d_i;
                    s_state <= '0'; 
                end if;
            end if;
        end if;
    end process;
    q_o <= s_reg_data;
end Behavioral;


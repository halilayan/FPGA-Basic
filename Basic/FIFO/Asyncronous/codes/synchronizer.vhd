----------------------------------------------------------------------------------
 
-- Engineer: Halil Ibrahim Ayan
-- Module Name: top_async_fifo - Behavioral
-- Project Name: asyncron fifo
-- Revision 0.01 - File Created

-- 
----------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;

entity synchronizer is
	 generic (DEPTH : natural := 4
			 );	
    port (
        clk_i	 : in std_logic;
        rst_i 	 : in std_logic;
        async_i  : in std_logic_vector(DEPTH downto 0);
        sync_o 	 : out std_logic_vector(DEPTH downto 0)
    );
end synchronizer;

architecture two_ff_arch of synchronizer is
    signal meta_reg_s 	: std_logic_vector(DEPTH downto 0);
	signal meta_next_s	: std_logic_vector(DEPTH downto 0);
    signal sync_reg_s   : std_logic_vector(DEPTH downto 0);   
    signal sync_next_s	: std_logic_vector(DEPTH downto 0);

begin
           
    process (clk_i, rst_i)
        begin
            if (rst_i = '1') then
                meta_reg_s <= (others => '0');
                sync_reg_s <= (others => '0');
            elsif rising_edge(clk_i) then   
                meta_reg_s <= meta_next_s;
                sync_reg_s <= sync_next_s;
            end if;
    end process;
      
    -- next-state logic
    meta_next_s <= async_i;
    sync_next_s <= meta_reg_s;
      
      
    -- output
    sync_o <= sync_reg_s;
    
 
 
--   -- Gray to Binary dönüþüm
--    binary_s(DEPTH) <= async_i(DEPTH); -- En üst bit aynen alýnýr
--    gen_gray_to_binary: for i in DEPTH-1 downto 0 generate
--        binary_s(i) <= async_i(i) xor binary_s(i+1);
--    end generate;

--    -- Next-state logic
--    meta_next_s <= binary_s; -- Gray'den dönüþtürülen binary deðer meta_reg_s'ye atanýr
--    sync_next_s <= meta_reg_s;
           
--    process (clk_i, rst_i)
--        begin
--            if (rst_i = '1') then
--                meta_reg_s <= (others => '0');
--                sync_reg_s <= (others => '0');
--            elsif rising_edge(clk_i) then   
--                meta_reg_s <= meta_next_s;
--                sync_reg_s <= sync_next_s;
--            end if;
--    end process;
      
--    -- Output
--    sync_o <= sync_reg_s;
end two_ff_arch;

----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Halil İbrahim Ayan
-- 
-- Create Date: 
-- Design Name: 
-- Module Name: tb_sync_fifo - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 1.0
-- Description: This is a simple syncronous FIFO. 16 pieces of 8-bit data can be written to this fifo.
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;


entity tb_sync_fifo is

end tb_sync_fifo;

architecture Behavioral of tb_sync_fifo is

	constant c_fifo_depth : natural := 16;
	constant c_fifo_width : integer := 8;

	signal	s_d_in		:  std_logic_vector (c_fifo_width-1 downto 0);
	signal	s_wr_en 	:  std_logic := '0';
	signal	s_rd_en		:  std_logic := '0';
	signal	s_clk		:  std_logic := '0';
	signal	s_rst		:  std_logic := '0';
	signal	s_d_out		:  std_logic_vector (c_fifo_width-1 downto 0);
	signal	s_full		:  std_logic;
	signal	s_empty		:  std_logic;
	

	
	constant clk_i_period : time := 10ns;
	
	
	component sync_fifo is
	
		generic(
				fifo_width : natural := 8;
				fifo_depth : integer := 16			
				);
	
		port (
				d_in_i	: in std_logic_vector ((fifo_width - 1) downto 0);
				wr_en_i : in std_logic;
				rd_en_i	: in std_logic;
				clk_i	: in std_logic;
				rst_i	: in std_logic;
				d_out_o	: out std_logic_vector ((fifo_width - 1) downto 0);
				full_o	: out std_logic;
				empty_o	: out std_logic
			);
	end component;


	begin
	
	uut: sync_fifo 
	generic map(
					fifo_width => c_fifo_width,
					fifo_depth => c_fifo_depth
					)
		
		port map(
					d_in_i	=> s_d_in,
					wr_en_i => s_wr_en,
					rd_en_i	=> s_rd_en,
					clk_i	=> s_clk,
					rst_i	=> s_rst,	
					d_out_o	=> s_d_out,
					full_o	=> s_full,
					empty_o	=> s_empty
				);			
	
	clk_i_process:	 process
						begin
							s_clk <= '0';
							wait for clk_i_period/2;
							s_clk <= '1';
							wait for clk_i_period/2;
					end process;
	
	
	--test
	test_process:	process
						begin
						s_rst <= '1';
						wait for clk_i_period*2;
						s_rst <= '0';	
						wait for clk_i_period*2;	
						
						s_wr_en <= '1';
						s_d_in <= X"A3";
						wait for clk_i_period*4;
						s_wr_en <= '0';
						s_rd_en <= '1';
						wait for clk_i_period*3;
						
						s_d_in <= X"B7";
						s_rd_en <= '0';
						s_wr_en <= '1';
						wait for clk_i_period*2;
						
						s_d_in <= X"F5";
						s_rd_en <= '1';
						wait for clk_i_period*10;
						
						
						s_rd_en <= '0';
						s_d_in <= X"C3";
						wait for clk_i_period*15;
						s_wr_en <= '0';
						wait;						
					end process;
	

	end Behavioral;

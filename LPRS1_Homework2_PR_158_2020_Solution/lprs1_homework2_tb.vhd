
library ieee;
use ieee.std_logic_1164.all;

library work;

entity lprs1_homework2_tb is
end entity;

architecture arch of lprs1_homework2_tb is
	
	constant i_clk_period : time := 4 ns; -- 250 MHz
	
	signal i_clk    : std_logic;
	signal i_rst    : std_logic;
	signal i_run    : std_logic;
	signal i_pause  : std_logic;
	
	signal o_digit0 : std_logic_vector(3 downto 0);
	signal o_digit1 : std_logic_vector(3 downto 0);
	signal o_digit2 : std_logic_vector(3 downto 0);
	signal o_digit3 : std_logic_vector(3 downto 0);
	
begin
	
	uut: entity work.lprs1_homework2
	port map(
		i_clk    => i_clk,
		i_rst    => i_rst,
		i_run    => i_run,
		i_pause  => i_pause,
		o_digit0 => o_digit0,
		o_digit1 => o_digit1,
		o_digit2 => o_digit2,
		o_digit3 => o_digit3
	);
	
	clk_p: process
	begin
		i_clk <= '1';
		wait for i_clk_period/2;
		i_clk <= '0';
		wait for i_clk_period/2;
	end process;
	
	stim_p: process
	begin
		-- Test cases:
		i_run <= '0';
		i_pause <= '0';
		
		--i_rst na 1us - pola takta--
		i_rst <= '1';
		wait for 1us - (i_clk_period / 2);
		i_rst <= '0';
		
		--jos pola takta--
		wait for i_clk_period / 2; 
		
		--i_run (o_digit0 da je 1)--
		i_run <= '1';
		wait for i_clk_period;
		i_run <= '0';
		
		--pauzirana stoperica na jedan period takta--
		i_pause <= '1';
		wait for i_clk_period;
		i_pause <= '0';
		--i_run na 1 pola takta--
		i_run <= '1';
		wait for i_clk_period;
		i_run <= '0';
		
		--i_run na 1 --
		i_run <= '1';
		
		--o_digit0 sa 3 na 4  resetovanje--
		wait for 1000 * i_clk_period;
		i_rst <= '1';
		--pustanje i_rst na 6us--
		wait for 6us;
		i_rst <= '0';
		
		--o_digit0 na 3, o_digit1 na 2 pa reset--
		wait for 6275 * i_clk_period; --36 100 - 11 000 = 25 100 / 4--
		wait for i_clk_period;			
		i_rst <= '1';
		wait for i_clk_period;
		i_rst <= '0';
		
		--o_digit0 na 5, o_digit1 na 1--
		wait for 4025 * i_clk_period; --52 200 - 36 100 = 16 100 / 4--
		wait for i_clk_period;
		
		--i_rst na jedan takt--
		i_rst <= '1';
		wait for i_clk_period;
		i_rst <= '0';
		
		wait;
	end process;
	
	
end architecture;

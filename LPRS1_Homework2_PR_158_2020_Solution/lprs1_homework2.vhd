
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
-- Libraries.

entity lprs1_homework2 is
	port(
		i_clk    :  in std_logic;
		i_rst    :  in std_logic;
		i_run    :  in std_logic;
		i_pause  :  in std_logic;
		o_digit0 : out std_logic_vector(3 downto 0);
		o_digit1 : out std_logic_vector(3 downto 0);
		o_digit2 : out std_logic_vector(3 downto 0);
		o_digit3 : out std_logic_vector(3 downto 0)
	);
end entity;


architecture arch of lprs1_homework2 is
	-- Signals.
signal s_en_1us : std_logic;
signal s_cnt_1us : std_logic_vector(7 downto 0);
constant Moduo250 : std_logic_vector(7 downto 0) := "11111010"; --250
signal s_tc_1us : std_logic;
signal s_en0 : std_logic;
constant Moduo10 : std_logic_vector(3 downto 0) := "1010"; --10 
signal s_cnt0 : std_logic_vector(3 downto 0);
signal s_tc0 : std_logic;
signal s_cnt1 : std_logic_vector(3 downto 0);
signal s_en1 : std_logic;
constant Moduo3 : std_logic_vector(3 downto 0) := "0011"; --3
signal s_tc1 : std_logic;

	
begin
	-- Body.
	
	--Kontrola dozvole brojanja pomocu stoperice--
	process(i_clk, i_rst) begin
		if(i_rst = '1') then
			s_en_1us <= '0';
		elsif(i_clk'event and i_clk = '1') then
			if(i_rst = '1') then
				s_en_1us <= '0';
			elsif(i_run = '1') then
				s_en_1us <= '1';
			elsif(i_pause = '1') then
				s_en_1us <= '0';	
			elsif(i_run = '1' and i_pause = '1') then
				s_en_1us <= '1';
			end if;
		end if;
	end process;
	
	--Brojac 1us--
	process(i_clk, i_rst) begin
		if(i_rst = '1') then
			s_cnt_1us <= (others => '0');
		elsif(i_clk'event and i_clk = '1') then
			if(s_en_1us = '1') then
				if(s_cnt_1us < Moduo250) then
					s_cnt_1us <= s_cnt_1us + 1;
				else
					s_cnt_1us <= (others => '0');				
				end if;
			end if;
		end if;
	end process;
	
	--s_tc_1us signal kraja brojanja kombinaciono--
	s_tc_1us <= '1' when s_cnt_1us = Moduo250 else '0';
	
	s_en0 <= s_en_1us and s_tc_1us;
	
	--Brojac jedne nulte cifre--
	process(i_clk, i_rst) begin
		if(i_rst = '1') then
			s_cnt0 <= (others => '0');
		elsif(i_clk'event and i_clk = '1') then
			if(s_en0 = '1') then
				if(s_cnt0 < Moduo10) then
					s_cnt0 <= s_cnt0 + 1;	
				else
					s_cnt0 <= (others => '0');		
				end if;
			end if;
		end if;
	end process;
	--s_tc0 signal kraja brojanja kombinaciono--
	s_tc0 <= '1' when s_cnt0 = Moduo10 else '0';
	
	s_en1 <= s_en0 and s_tc0;
	--o_digit0 dobija vreddnost s_cnt--
	o_digit0 <= s_cnt0;
	
	--Brojac jedne prve cifre--
	process(i_clk, i_rst) begin
		if(i_rst = '1') then
			s_cnt1 <= (others => '0');
		elsif(i_clk'event and i_clk = '1') then
			if(s_en1 = '1') then
				if(s_cnt1 < Moduo3) then
					s_cnt1 <= s_cnt1 + 1; 
				else
					s_cnt1 <= (others => '0');
				end if;
			end if;
		end if;
	end process;
	
	--s_tc1 signal kraja brojanja kombinaciono--
	s_tc1 <= '1' when s_cnt1 = Moduo3 else '0';
	
	--o_digit1 dobija vrednost s_cnt1--
	o_digit1 <= s_cnt1;
	--o_digit2 dobija vrednost 4--
	o_digit2 <= "0100";
	--o_digit3 dobija vrednost 11--
	o_digit3 <= "1011";
	
	
end architecture;

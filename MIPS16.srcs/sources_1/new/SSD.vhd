----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.03.2023 09:15:27
-- Design Name: 
-- Module Name: SSD - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
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
use IEEE.std_logic_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SSD is
Port(clk: in std_logic;
LED: out std_logic_vector(6 downto 0);
counter: in std_logic_vector(15 downto 0);
iesire_an: out std_logic_vector(3 downto 0));
end SSD;

architecture Behavioral of SSD is

signal iesire_cat:std_logic_vector(3 downto 0);
signal cnt:std_logic_vector(15 downto 0);

begin 

process(clk)
begin 
if rising_edge(clk) then 
cnt<=cnt+1;
end if;
end process;

process(cnt(15 downto 14), iesire_cat)
begin
case cnt(15 downto 14) is
when "11" => iesire_cat<= counter(15 downto 12);
when "10" => iesire_cat<= counter(11 downto 8);
when "01" => iesire_cat<= counter(7 downto 4);
when others => iesire_cat<= counter(3 downto 0) ;
end case;
end process;

process(cnt(15 downto 14))
begin 
case cnt(15 downto 14) is
when "00" => iesire_an<= "1110";
when "01" => iesire_an<= "1101";
when "10" => iesire_an<= "1011";
when others => iesire_an<= "0111";
end case;
end process;


process(iesire_cat)
begin 
case iesire_cat is
      when "0000" => LED<= "1000000";  --0
      when "0001" => LED<= "1111001";   --1
      when "0010" =>LED<="0100100"; --2
      when "0011"=> LED<= "0110000";  --3
      when "0100" => LED<="0011001";   --4
      when "0101" => LED<= "0010010";  --5
      when "0110" => LED<= "0000010";  --6
      when "0111" => LED<= "1111000"; --7
      when "1000" => LED<="0000000"; --8
      when "1001" => LED<="0010000"; 
      when "1010"=> LED<= "0001000";  --A
      when "1011"=> LED<="0000011";  --b
      when "1100" => LED<="1000110";  --C
      when "1101" => LED<= "0100001"; --d
      when "1110" => LED<=  "0000110";   --E
      when "1111" => LED<="0001110";  --F
      when others => LED<="1000000";  
end case;
end process;
end Behavioral;

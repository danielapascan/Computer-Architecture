----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.03.2023 11:10:48
-- Design Name: 
-- Module Name: mpg - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity GeneratorMonoimpulsSincron is
 Port (buton: in std_logic;
 clock: in std_logic;
 enable: out std_logic );
end GeneratorMonoimpulsSincron;

architecture Behavioral of GeneratorMonoimpulsSincron is
signal count: std_logic_vector(31 downto 0);
signal Q1: std_logic;
signal Q2:std_logic;
signal Q3:std_logic;

begin

enable<= Q2 and (not Q3);

process(clock)
begin 
 if rising_edge(clock) then
  if count(15 downto 0)="111111111111111" then
  Q1<=buton;
  end if;
  end if;
end process;

process(clock)
begin
if rising_edge(clock) then
 Q2<=Q1;
 Q3<=Q2;
 end if;
end process;

process(clock)
begin 
if rising_edge(clock)then
 count<=count +1;
end if;
end process;

end Behavioral;


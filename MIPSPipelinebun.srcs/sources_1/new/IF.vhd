----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/06/2023 02:48:12 PM
-- Design Name: 
-- Module Name: UnitateIF - Behavioral
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

entity UnitateIF is
    Port(   clk: in std_logic;
            en_PC: in std_logic;
            en_reset: in std_logic;
            branch_address: in std_logic_vector(15 downto 0);
            jump_address: in std_logic_vector(15 downto 0);
            jump: in std_logic;
            PCSrc: in std_logic;
            instruction: out std_logic_vector(15 downto 0);
            next_instruction_address: out std_logic_vector(15 downto 0));
end UnitateIF;

architecture Behavioral of UnitateIF is

signal PC: std_logic_vector(15 downto 0) := (others => '0');
signal out_MUX_JA: std_logic_vector(15 downto 0);
signal out_MUX_BA: std_logic_vector(15 downto 0);
signal out_sum: std_logic_vector(15 downto 0);
type mem_rom is array (0 to 255) of std_logic_vector (15 downto 0);
signal ROM : mem_rom:= ( 
B"000_000_000_000_0_110",   --xor $0, $0, 0          (6)     punem 0 in registrul 0  
B"000_000_000_000_0_000",
B"000_000_000_000_0_000",
B"001_000_011_0000000",     -- addi $3, $0, 0        (2180)  punem 0 in registrun 3(aici se face suma)
B"001_000_010_0000001",     --addi $2,$0,1           (2101)  punem 1 in  registrul 2( il folosim pe post de contor)
B"001_000_110_0000001",     --addi $6 $0, 1          (2301)  punem 1 in registrul 6(cu el luam elementele din memorie)
B"001_000_100_0001011",     --addi $4 , $0, 11       (220B)  punem in registrul 4 numarul de elemente din sir  
B"100_100_010_0001011",     --beq $2, $4,11          (9105)  comparam contorul cu finalul sirului  
B"000_000_000_000_0_000",
B"000_000_000_000_0_000",
B"000_000_000_000_0_000", 
B"010_110_101_0000000",     --lw $5, ($6)            (5A80)  luam elementul din memorie
B"000_000_000_000_0_000",
B"000_000_000_000_0_000",
B"000_011_101_011_0_000",   -- add $3, $3, $5        (EB0)   adaugam elementul la suma 
B"001_010_010_0000010",     -- addi $2, $2, 2        (2902)  crestem contorul cu 2 deoarece trecem prin pozitiile impare
B"001_110_110_0000010",     --addi $6, $6, 2         (3B02)  crestem adresa de memorie cu 2 deoarece trecem peste un element
B"111_0000000000111",       --j 7                    (E005)  sarim la instructiunea beg 
B"000_000_000_000_0_000",
B"011_011_011_0000000",      --sw $3, sum_address($3) (6D80)  stocam suma obtinuta in regisrul 1 
    others => X"0000");
begin

process(jump)
begin 
    case jump is
        when '0' => out_MUX_JA <= out_MUX_BA;
        when '1' => out_MUX_JA <= jump_address;
        when others => out_MUX_JA <= x"0000";
    end case;
end process;

process(PCSrc)
begin
    case PCSrc is
        when '0' => out_MUX_BA <= out_sum;
        when '1' => out_MUX_BA <= branch_address;
        when others => out_MUX_BA <= x"0000";
    end case;
end process;


process(clk, en_PC, en_reset)
begin
    if rising_edge(clk) then
        if en_reset = '1' then 
            PC <= x"0000"; 
        elsif en_PC = '1' then
            PC <= out_MUX_JA;
        end if;
    end if;
end process;
out_sum <= PC + 1;

next_instruction_address <= out_sum;

instruction <= ROM(conv_integer(PC(6 downto 0)));

end Behavioral;
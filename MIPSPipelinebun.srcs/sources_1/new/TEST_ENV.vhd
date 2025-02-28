----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.03.2023 21:50:21
-- Design Name: 
-- Module Name: test_env - Behavioral
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
use ieee.numeric_std.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_env is
Port (clk:in std_logic;
btn:in std_logic_vector(4 downto 0);
sw: in std_logic_vector(15 downto 0);
led: out std_logic_vector(15 downto 0);
an: out std_logic_vector(3 downto 0);
cat: out std_logic_vector(6 downto 0));
end test_env;

architecture Behavioral of test_env is

component UnitateIF
    Port(  clk: in std_logic;
            en_PC: in std_logic;
            en_reset: in std_logic;
            branch_address: in std_logic_vector(15 downto 0);
            jump_address: in std_logic_vector(15 downto 0);
            jump: in std_logic;
            PCSrc: in std_logic;
            instruction: out std_logic_vector(15 downto 0);
            next_instruction_address: out std_logic_vector(15 downto 0));
end component;

component ID is
    Port(
        RegWrite: in std_logic;
        Instr: in std_logic_vector(15 downto 0);
       -- RegDst: in std_logic;
        clk: in std_logic;
        en:in std_logic;
        ExtOp: in std_logic;
        WD:in std_logic_vector(15 downto 0);
        WA: in std_logic_vector(2 downto 0);
        RD1: out std_logic_vector(15 downto 0);
        RD2: out std_logic_vector (15 downto 0);
        Ext_imm: out std_logic_vector (15 downto 0);
        func: out std_logic_vector(2 downto 0);
        sa : out std_logic;
        rt: out std_logic_vector(2 downto 0);
        rd: out std_logic_vector(2 downto 0));
end component;

component UC is
Port( Instr:in std_logic_vector(15 downto 0);
    RegDst: out std_logic;
    ExtOp: out std_logic;
    ALUSrc: out std_logic;
    Branch: out std_logic;
    Jump: out std_logic;
    ALUOp: out std_logic_vector (2 downto 0);
    MemWrite: out std_logic;
    MemToReg: out std_logic;
    RegWrite: out std_logic);
end component;

component EX is
    Port(
     RD1: in std_logic_vector(15 downto 0);
    RD2: in std_logic_vector (15 downto 0);
    ALUSrc: in std_logic;
    Ext_imm: in std_logic_vector(15 downto 0);
    sa: in std_logic;
    func: in std_logic_vector(2 downto 0);
    ALUOp: in std_logic_vector (2 downto 0);
    PCplus1: in std_logic_vector (15 downto 0);
    Zero: out std_logic;
    ALURes: out std_logic_vector (15 downto 0);
    BranchAddress: out std_logic_Vector(15 downto 0);
    rt: in std_logic_vector(2 downto 0);
    rd: in std_logic_vector(2 downto 0);
    RegDst: in std_logic;
    rWA: out std_logic_vector(2 downto 0));
    --GT: out std_logic);
end component;

component MEM is
    Port(
    MemWrite: in std_logic;
    ALUResIn: in std_logic_vector(15 downto 0);
    RD2: in std_logic_vector (15 downto 0);
    clk: in std_logic;
    en: in std_logic;
    MemData: out std_logic_vector(15 downto 0);
    ALUResOut: out std_logic_vector (15 downto 0));
end component;

signal out1 : std_logic_vector (15 downto 0);
signal enable1, enable2: std_logic;
signal PCplus1:  std_logic_vector(15 downto 0);
signal Instruction:  std_logic_vector (15 downto 0);
signal Jump, MemToReg, MemWrite, Branch, ALUSrc :std_logic;
signal RegWrite, RegDst, ExtOp, sa: std_logic;
signal ALUOp: std_logic_vector (2 downto 0);
signal RD1, RD2, ExtImm, WD: std_logic_vector (15 downto 0);
signal func: std_logic_vector (2 downto 0);
signal JumpAddress, BranchAddress, ALURes, MemData, ALUResOut: std_logic_vector(15 downto 0);
signal PCSrc, Zero :std_logic;

signal GT: std_logic;
signal rd, rt, rWA, WA: std_logic_vector(2 downto 0);

signal IF_ID: std_logic_vector (31 downto 0);
signal ID_EX: std_logic_vector (66 downto 0);
signal EX_MEM: std_logic_vector (55 downto 0);
signal MEM_WB: std_logic_vector (36 downto 0);

signal IF_ID_out: std_logic_vector (31 downto 0);
signal ID_EX_out: std_logic_vector (66 downto 0);
signal EX_MEM_out: std_logic_vector (55 downto 0);
signal MEM_WB_out: std_logic_vector (36 downto 0);

begin

process(clk)
    begin
    if rising_edge(clk) then
        if enable1='1' then
            IF_ID_out<=IF_ID;
            ID_EX_out<=ID_EX;
            EX_MEM_out<=EX_MEM;
            MEM_WB_out<=MEM_WB;
        end if;
    end if;
    end process;

IF_ID<=Instruction & PCplus1;
ID_EX<=rt & rd & sa & ExtImm & RD2 & RD1 & func & RegDst & ALUSrc & ALUOp & Branch & MemWrite & RegWrite & MemToReg;
EX_MEM<=rWA & ID_EX_out(43 downto 28) & ALURes & zero &  BranchAddress & ID_EX_out(3 downto 0) ;
MEM_WB<=EX_MEM_out(55 downto 53) & ALUResOut & MemData & EX_MEM_out(1 downto 0);


led(10 downto 0)<= ALUOp & RegDst & ExtOp & ALUSrc & Branch & Jump & MemWrite & MemToReg & RegWrite; 

JumpAddress<=IF_ID_out(15 downto 13) & IF_ID_out(28 downto 16);
WD<=MEM_WB_out(33 downto 18) when MemToReg='0' else MEM_WB_out(17 downto 2);
PCSrc<=EX_MEM(3) and EX_MEM(20);

MPG1 : entity WORK.GeneratorMonoimpulsSincron port map(btn(0), clk, enable1);

MPG2 : entity WORK.GeneratorMonoimpulsSincron port map( btn(1), clk, enable2);

IF1 : entity WORK.UnitateIF port map (clk, enable1, enable2, EX_MEM_out(19 downto 4),JumpAddress, Jump,PCSrc, Instruction, PCplus1);

ID1: ID port map (RegWrite, IF_ID_out(31 downto 16), clk, enable1, ExtOp,WD, MEM_WB_out(36 downto 34), RD1, RD2, ExtImm, func, sa, rt, rd);

UC1: UC port map (IF_ID_out(31 downto 16), RegDst, ExtOp, ALUSrc, Branch, Jump, ALUOp, MemWrite, MemToReg, RegWrite);

EX1: EX port map (ID_EX_out(27 downto 12), ID_EX_out(43 downto 28), ID_EX_out(7), ID_EX_out(59 downto 44), ID_EX_out(60), ID_EX_out(11 downto 9), ID_EX_out(6 downto 4), IF_ID_out(15 downto 0),Zero,ALURes,BranchAddress, ID_EX_out(66 downto 64), ID_EX_out(63 downto 61), ID_EX_out(8), rWA);

MEM1: MEM port map (EX_MEM_out(2), EX_MEM_out(36 downto 21), EX_MEM_out(52 downto 37), clk, enable1, MemData, ALUResOut);

SSD1 : entity WORK.SSD port map(clk, cat,out1 ,an);

with sw(7 downto 5) Select
out1<=Instruction when "000",
    PCPlus1 when "001",
    RD1 when "010",
    RD2 when "011",
    ExtImm when "100",
    ALURes when "101",
    MemData when "110",
    WD when "111",
    (others=>'X') when others; 

end Behavioral;

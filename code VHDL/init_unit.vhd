library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fixed_point_pkg.all;

entity init_unit is
    port (
        clk    : in  std_logic;
        en     : in  std_logic;
        r_in   : in  q8_24;
        x_out  : out q8_24;
        y_out  : out q8_24;
        z_out  : out q8_24;
        done   : out std_logic
    );
end entity;

architecture rtl of init_unit is
begin
    process(clk)
    begin
        if rising_edge(clk) then
            done <= '0';
            if en = '1' then
                x_out <= K_INV_Q;
                y_out <= (others => '0');
                z_out <= r_in;
                done <= '1';
            end if;
        end if;
    end process;
end architecture;

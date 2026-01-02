library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fixed_point_pkg.all;

entity result_unit is
    port (
        clk    : in  std_logic;
        en     : in  std_logic;
        x_in   : in  q8_24;
        y_in   : in  q8_24;
        k_in   : in  integer;
        y_out  : out q8_24;
        done   : out std_logic
    );
end entity;

architecture rtl of result_unit is
begin
    process(clk)
	variable sum_xy  : signed(x_in'range);
    	variable shifted : signed(x_in'range);
    begin
        if rising_edge(clk) then
            done <= '0';
            if en = '1' then
                sum_xy  := x_in + y_in;
                shifted := shift_left(sum_xy, k_in);

                y_out <= shifted;
                done  <= '1';
            end if;
        end if;
    end process;

end architecture;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fixed_point_pkg.all;
use work.cordic_lut_pkg.all;

entity cordic_unit is
    port (
        clk    : in  std_logic;
        en     : in  std_logic;

        dir    : in  std_logic;
        x_in   : in  q8_24;
        y_in   : in  q8_24;
        z_in   : in  q8_24;
        iter   : in  integer range 0 to N_ITER;
        x_out  : out q8_24;
        y_out  : out q8_24;
        z_out  : out q8_24;

	shid_test : out integer;
	xsh_test : out q8_24;
	ysh_test : out q8_24;

        done   : out std_logic
    );
end entity;

architecture rtl of cordic_unit is
    signal shift_idx : integer;
    signal x_shift, y_shift : q8_24;
begin
    shift_idx <= SEQ_ROM(iter);
    x_shift <= shift_right(x_in, shift_idx);
    y_shift <= shift_right(y_in, shift_idx);

    process(clk)
    begin
        if rising_edge(clk) then
            done <= '0';
            if en = '1' then
                if dir = '0' then
                    -- z >= 0
                    x_out <= x_in + y_shift;
                    y_out <= y_in + x_shift;
                    z_out <= z_in - resize(ATANH_LUT(iter), z_in'length);
                else
                    -- z < 0
                    x_out <= x_in - y_shift;
                    y_out <= y_in - x_shift;
                    z_out <= z_in + resize(ATANH_LUT(iter), z_in'length);
                end if;

		shid_test <= shift_idx;
		xsh_test  <= x_shift;
		ysh_test  <= y_shift;

                done <= '1';
            end if;
        end if;
    end process;
end architecture;

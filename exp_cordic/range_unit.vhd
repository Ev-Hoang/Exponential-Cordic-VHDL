library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fixed_point_pkg.all;

entity range_unit is
    port(
        clk   : in  std_logic;
        en    : in  std_logic;
        t_in  : in  q8_24;
        k_out : out integer;
        r_out : out q8_24;
        done  : out std_logic;

	mul_test: out q16_48
    );
end entity;

architecture rtl of range_unit is
    signal mul_reg : q16_48 := (others => '0');
    signal k_reg   : integer;
    signal k_ln2   : q8_24;
    signal r_reg   : q8_24;
    signal done_reg : std_logic := '0';
begin

process(clk)
    variable k_mul   : q16_48;
    variable k_floor : integer;
    variable k_ln2   : q8_24;
begin
    if rising_edge(clk) then
        done_reg <= '0';
        if en = '1' then
            k_mul := t_in * INV_LN2_Q;  -- Q16.48

	            if k_mul(63) = '0' then  
                k_mul := k_mul + EPS_Q16_48;
            else                     
                k_mul := k_mul - EPS_Q16_48;
            end if;

            k_floor := to_integer(k_mul(63 downto 48));

            k_ln2 := resize(signed(to_signed(k_floor, 32)) * LN2_Q, 32); -- Q8.16
            r_reg <= t_in - k_ln2;                                       -- Q8.16
            k_reg <= k_floor;

            mul_reg <= k_mul;

            done_reg <= '1';
        end if;
    end if;
end process;

    k_out <= k_reg;
    r_out <= r_reg;
    done  <= done_reg;
    mul_test <= mul_reg;

end architecture;

